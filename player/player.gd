class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
const SPRINT_MODIFIER = 1.5
const AMMO_CAPACITY = 12
const GRENADE_CAPCITY = 2
const STAMINA_CAPACITY = 200
@export var BULLET_SPEED = 8.0

@export var camera: Camera3D
@export var head: Node3D

@onready var ammo_label := $AmmoLabel
@onready var grenade_label := $GrenadeLabel
@onready var bullet_spawn = $Head/Camera3D/BulletSpawn
@onready var stamina_bar = $StaminaBar

var bullet_scene = preload("res://objects/bullet.tscn")
var grenade_scene = preload("res://objects/grenade.tscn")
var ammo = AMMO_CAPACITY
var grenades = GRENADE_CAPCITY
var stamina = STAMINA_CAPACITY

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	stamina_bar.value = stamina

func _input(event):
	# Ensures we can hit escape to free the mouse for testing purposes
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Fire a bullet
	if event.is_action_pressed("click") and ammo > 0:
		fire_bullet()
	# Throw a grenade
	if event.is_action_pressed("grenade") and grenades > 0:
		throw_grenade()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# If sprinting changes sprint to sprint modifier
	var sprint = 1
	if Input.is_action_pressed("sprint") and stamina > 0:
		sprint = SPRINT_MODIFIER
		stamina -= 1
	else:
		# Makes sure we don't go over stamina capcity
		stamina = min(stamina + 1, STAMINA_CAPACITY)
	# Update stamina bar graphic	
	stamina_bar.value = stamina
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * sprint
		velocity.z = direction.z * SPEED * sprint
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

# Fires a bullet
func fire_bullet():
	var bullet = bullet_scene.instantiate()
	add_sibling(bullet)
	bullet.transform = bullet_spawn.global_transform
	bullet.linear_velocity = bullet_spawn.global_transform.basis.z * -1 * BULLET_SPEED
	ammo -= 1
	ammo_label.text = "Ammo: " + str(ammo)
	
func throw_grenade():
	var grenade = grenade_scene.instantiate()
	add_sibling(grenade)
	grenade.transform = bullet_spawn.global_transform
	grenade.linear_velocity = bullet_spawn.global_transform.basis.z * -1 * 0.5
	grenades -= 1
	grenade_label.text ="Grenades: " + str(grenades)
	
func reload_ammo():
	ammo = AMMO_CAPACITY
	grenades = GRENADE_CAPCITY
	ammo_label.text = "Ammo: " + str(ammo)
	grenade_label.text ="Grenades: " + str(grenades)

func _on_detector_body_entered(body: Node3D) -> void:
	print("You died! RIP")
