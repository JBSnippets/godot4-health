## A simple health growl label component to show the amount of health changed.[br][br]
## 
## The label will float above the character.
class_name HealthGrowlLabel
extends Label

## The floating speed of the label.
@export var float_speed: Vector2 = Vector2(0, -60)

## Returns the object's class name, as a [String].
func get_class_name() -> String: return "HealthGrowlLabel"

func _process(delta) -> void:
	position += float_speed * delta

func _on_timer_timeout() -> void:
	queue_free()
