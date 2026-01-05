extends RigidBody3D

const SPEED = 1.0

var angle: Vector3 = Vector3(0, 0, 0)
var velocity: Vector3


func _physics_process(delta: float) -> void:
	velocity = angle * SPEED
	print(angle)
	var collision = move_and_collide(velocity)
