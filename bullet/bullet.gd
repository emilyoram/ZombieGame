extends RigidBody3D

func _ready() -> void:
	add_to_group("bullets")

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	var collisions = move_and_collide(linear_velocity)
	if collisions != null:
		if collisions.get_collider().is_in_group("zombies"):
			collisions.get_collider()._hit_by_bullet()
		queue_free()
