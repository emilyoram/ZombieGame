extends Label

var score = 0

func _ready():
	var zombies = get_tree().get_nodes_in_group("zombies")
	for zombie in zombies:
		zombie.hit_by_bullet.connect(_on_enemy_hit_by_bullet)

func _on_enemy_hit_by_bullet() -> void:
	score += 1
	text = "Zombies Killed: " + str(score)

# Makes sure that when a new zombie spawns we're listening if they get hit
func _on_zombie_spawner_zombie_spawned() -> void:
	var zombies = get_tree().get_nodes_in_group("zombies")
	for zombie in zombies:
		if not zombie.hit_by_bullet.is_connected(_on_enemy_hit_by_bullet):
			zombie.hit_by_bullet.connect(_on_enemy_hit_by_bullet)
