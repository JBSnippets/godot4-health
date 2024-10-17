extends CanvasLayer

var player

func _ready() -> void:
	player = get_parent().get_node("Player")

func _on_revive_pressed() -> void:
	if player and player.health.amount <= 0:
		player.health_update(30)
		print("I'm alive!")
