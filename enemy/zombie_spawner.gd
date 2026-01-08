extends Node3D

const ZOMBIES_BEFORE_SPEED_INCREASE = 8
const ZOMBIE_LIMIT = 8

@export var initial_spawn_time = 5.05

@onready var zombie_scene = preload("res://enemy/zombie.tscn")
@onready var spawn_timer = $SpawnTimer

var zombies = 0

signal zombie_spawned

func _ready() -> void:
	spawn_timer.wait_time = initial_spawn_time

func spawn_zombie():
	var zombie = zombie_scene.instantiate()
	var random_x = randf_range(global_position.x - 10, global_position.x + 10)
	var random_z = randf_range(global_position.z - 10, global_position.z + 10)
	add_child(zombie)
	zombie.global_position.x = random_x
	zombie.global_position.z = random_z
	zombie_spawned.emit()
	zombies += 1
	if zombies >= ZOMBIES_BEFORE_SPEED_INCREASE:
		print("speed increased")
		zombies = 0
		spawn_timer.wait_time = max(spawn_timer.wait_time - 0.5, 1.55)
		print(str(spawn_timer.wait_time))
	
func _on_spawn_timer_timeout() -> void:
	# Checks to make sure we don't spawn too many zombies that the game can't handle it
	if len(get_tree().get_nodes_in_group("zombies")) < ZOMBIE_LIMIT:
		spawn_zombie()
