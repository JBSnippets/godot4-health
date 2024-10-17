extends Area2D

@export var damage: int = -10

func _on_body_entered(body) -> void:
	if body.has_method("health_update"):
		body.health_update(damage)
