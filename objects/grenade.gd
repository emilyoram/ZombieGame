class_name Zombie extends RigidBody3D

var explosion_scene = preload("res://objects/grenade_explosion.tscn")

func _physics_process(_delta: float) -> void:
	var collisions = move_and_collide(linear_velocity)
	if collisions != null:
		var explosion = explosion_scene.instantiate()
		add_sibling(explosion)
		explosion.global_position = global_position
		queue_free()
