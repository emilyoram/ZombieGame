extends Node3D

@onready var zombie_scene = preload("res://enemy/zombie.tscn")

signal zombie_spawned

func spawn_zombie():
	var zombie = zombie_scene.instantiate()
	add_child(zombie)
	zombie_spawned.emit()
	
func _on_spawn_timer_timeout() -> void:
	spawn_zombie()
