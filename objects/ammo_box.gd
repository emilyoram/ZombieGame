extends Area3D

var usable = true

@onready var mesh := $MeshInstance3D
@onready var timer := $RefreshTimer

func _on_body_entered(body: Node3D) -> void:
	if body is Player and usable == true:
		body.reload_ammo()
		usable = false
		hide()
		timer.start()

func _on_refresh_timer_timeout() -> void:
	usable = true
	show()
