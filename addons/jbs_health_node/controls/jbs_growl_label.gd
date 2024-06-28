extends Label

@export var float_speed: Vector2 = Vector2(0, -60)

func _process(delta):
	position += float_speed * delta

func _on_timer_timeout():
	queue_free()
