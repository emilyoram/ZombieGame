extends CharacterBody3D

signal hit_by_bullet

const SPEED = 7.0
var player
var direction
var player_nearby = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	add_to_group("zombies") # Used for signals
	player = get_tree().get_first_node_in_group("player")
	path_to_player()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_nav"):
		var random_position := Vector3.ZERO
		random_position.x = randf_range(-12.5, 12.5)
		random_position.z = randf_range(-12.5, 12.5)
		nav_agent.set_target_position(random_position)

func _hit_by_bullet():
	print("hit")
	hit_by_bullet.emit()
	queue_free()

func path_to_player():
	nav_agent.set_target_position(player.global_position)
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	direction = local_destination.normalized()

func _physics_process(delta: float) -> void:
	# If the player is nearby we recalculate the path to them more often
	if player_nearby:
		path_to_player()
	
	velocity = direction * SPEED
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	move_and_slide()


func _on_repath_timer_timeout() -> void:
	path_to_player()


func _on_player_detector_body_entered(body: Node3D) -> void:
	if body is Player:
		player_nearby = true

func _on_player_detector_body_exited(body: Node3D) -> void:
	if body is Player:
		player_nearby = false
