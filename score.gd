extends Label

var score = 0
var save_path = "user://score.save"

func _ready():
	var zombies = get_tree().get_nodes_in_group("zombies")
	for zombie in zombies:
		zombie.hit_by_bullet.connect(_on_enemy_hit_by_bullet)

func _on_enemy_hit_by_bullet() -> void:
	print("hit received")
	score += 1
	text = "Zombies Killed: " + str(score)

# Makes sure that when a new zombie spawns we're listening if they get hit
func _on_zombie_spawner_zombie_spawned() -> void:
	var zombies = get_tree().get_nodes_in_group("zombies")
	print(str(len(zombies)) + " zombies")
	for zombie in zombies:
		if not zombie.hit_by_bullet.is_connected(_on_enemy_hit_by_bullet):
			zombie.hit_by_bullet.connect(_on_enemy_hit_by_bullet)


func _on_player_died() -> void:
	# Save the high score to file
	if FileAccess.file_exists(save_path):
		print("File found!")
		var file = FileAccess.open(save_path, FileAccess.READ_WRITE)
		var highscore = file.get_var()
		if score > highscore:
			print("New high score: " + str(score))
			# Makes sure we're overwriting the inital variable and not just adding a new one
			file.seek(0)
			file.store_var(score)
			file.close()
	else:
		print("File not found")
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(score)
	
