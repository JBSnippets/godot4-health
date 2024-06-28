@tool
## A simple health growl component to manage floating text that displays the amount of health change.
##
## The health growler will display floating text for a specified number of seconds, using [member damage_color] if the amount is less than 0, and [member heal_color] if the amount is greater than 0.[br][br]
## [color=orange]NOTE[/color]: To enable the growler, add a [Marker2D] node to the target and name it GrowlPosition.
class_name HealthGrowler
extends Control

## The packed scene label to use for growling. An example growl label is included this plugin named JBSGrowlLabel
@export var growl_label: PackedScene

## The damage color of the floating text
@export var damage_color: Color = Color.RED

## The heal color of the floating text
@export var heal_color: Color = Color.GREEN

var _global_health

func _ready():
	if Engine.is_editor_hint(): return
	_global_health = get_tree().root.get_node("/root/GlobalHealth")
	if _global_health: _global_health.connect("update", _on_health_update)
		
func _on_health_update(body: Node, amount: int, health: int):
	var growl_position = body.find_child("GrowlPosition")
	if !growl_position: return
	var label: Label = growl_label.instantiate()
	label.text = str(amount)
	if amount > 0:
		label.modulate = heal_color
	else:
		label.modulate = damage_color
	growl_position.add_child(label)
