## A simple health growl component to manage floating text that displays the amount of health change.
##
## The health growler will display floating text for a specified number of seconds, using [member damage_color] if the amount is less than 0, and [member heal_color] if the amount is greater than 0.[br][br]
## [color=orange]NOTE[/color]: To enable the growler, add a [Marker2D] node to the target and name it GrowlPosition.
class_name HealthGrowler
extends Control

## The packed scene label to use for growling. An example growl label is included this plugin named JBSGrowlLabel
@export var growl_label: PackedScene

## The name of the Marker 2D node set as reference position when creating the label.
@export var marker_2d_name: String = "GrowlPosition"

## The damage color of the floating text
@export var damage_color: Color = Color.RED

## The heal color of the floating text
@export var heal_color: Color = Color.GREEN

## Returns the object's class name, as a [String].
func get_class_name() -> String: return "HealthGrowler"

func _ready() -> void:
	var global_health = get_tree().root.get_node("/root/GlobalHealth")
	if global_health: global_health.update.connect(_on_health_update)
		
func _on_health_update(body: Node, amount: int, health: int) -> void:
	var growl_position = body.find_child(marker_2d_name)
	if !growl_position: return
	var label: Label = growl_label.instantiate()
	label.text = str(amount)
	if amount > 0:
		label.modulate = heal_color
	else:
		label.modulate = damage_color
	growl_position.add_child(label)
