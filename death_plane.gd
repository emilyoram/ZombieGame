extends Area3D

# Kills the player if they fall off the map or deletes a zombie
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.die()
	elif body is Zombie:
		body.queue_free()
