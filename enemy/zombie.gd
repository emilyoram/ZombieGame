extends CharacterBody3D

signal hit_by_bullet

const SPEED = 7.0
var player

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	add_to_group("zombies") # Used for signals
	player = get_tree().get_first_node_in_group("player")
	
	
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

func _physics_process(delta: float) -> void:
	
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * SPEED
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	move_and_slide()


func _on_repath_timer_timeout() -> void:
	path_to_player()
