extends CharacterBody3D

signal hit_by_bullet

func _ready():
	add_to_group("enemies") # Used for signals

func _physics_process(delta: float) -> void:
	var test = Vector3(0, 0, 0)
	var collisions = move_and_collide(test)
	if collisions != null:
		hit_by_bullet.emit()
		queue_free()
	
