extends Label

var score = 0

func _ready():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.hit_by_bullet.connect(_on_enemy_hit_by_bullet)

func _on_enemy_hit_by_bullet() -> void:
	score += 1 # Replace with function body.
	text = str(score)
