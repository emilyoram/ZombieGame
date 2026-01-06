extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01
const SPRINT_MODIFIER = 1.5
@export var BULLET_SPEED = 8.0

@export var camera: Camera3D
@export var head: Node3D

@onready var bullet_spawn = $Head/Camera3D/BulletSpawn

var bullet_scene = preload("res://bullet/bullet.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("click"):
		fire_bullet()

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
	if Input.is_action_pressed("sprint"):
		sprint = SPRINT_MODIFIER
		
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
