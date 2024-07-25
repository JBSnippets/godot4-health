@tool
@icon("jbs_health_node.png")
## A custom node designed to store and update the health amount, emitting signals whenever the health amount changes.
##
## This custom node enables the addition of health capabilities, which can be adjusted by invoking the [method update_amount] function. It can automatically send signals based on changes in the health amount and set properties.
class_name Health
extends Node

## This signal is emitted when the health is updated. The parameter [param body] refers to the parent of this node, [param amount] is the value added to the health, and [param health] is the new health value after adding [param amount].[br][br]
##
## [color=orange]NOTE[/color]: If [param amount] is negative, the [signal damage] signal will be emitted; if it is positive, the [signal heal] signal will be emitted.[br][br]
##
## [color=orange]NOTE:[/color] If the JBS [code]GlobalHealth[/code] singleton is enabled, this signal is emitted on a global scale. The JBS [code]GlobalHealth[/code] singleton facilitates global relay of the [signal update] signal.
signal update(body: Node, amount: float, health: float)

## This signal is emitted when the health is updated with a negative amount.[br][br]
##
## [color=orange]NOTE[/color]: This is emitted only if [member damageable] and [member emit_damage] are set to true.
signal damage(damage: float, health: float)

## This signal is emitted when the health is updated with a positive amount.[br][br]
##
## [color=orange]NOTE[/color]: This is emitted only if [member healable] and [member emit_heal] are set to true.
signal heal(recovery: float, health: float)

## This signal is emitted when the health reaches or falls below 0.[br][br]
##
## [color=orange]NOTE[/color]: This is emitted only if [member damageable] and [member emit_death] are set to true.
signal death()

## This signal is emitted when the health is updated with a positive [param amount] while the current health value is 0 or negative.[br][br]
##
## [color=orange]NOTE[/color]: This is emitted only if [member revivable] and [member emit_revive] are set to true.
signal revive(amount: float, health: float)

## The current amount of health.
@export var amount: float = 100

## The maximum amount of health.
@export var max_amount: float = 100

@export_category("Interface")
## The visual representation of the health status using [TextureProgressBar].
@export var texture_progress: TextureProgressBar

## The visual representation of the health status using [ProgressBar].
@export var progress: ProgressBar

## The number of seconds until the health bar is hidden from view.[br][br]
##
## [color=orange]NOTE[/color]: If this value is set to 0, the health bar will remain visible at all times.
@export_range(0, 3) var hide_in_seconds: float = 0.5

enum _behaviors { 
	## Manual control
	default,
	## Automatically increase by change %
	auto_increase,
	## Automatically decrease by change %
	auto_decrease 
}
@export_category("Behavior")
## The behavior of the health node
@export var behavior: _behaviors = _behaviors.default

## The percentage of automatic change, calculated based on the [member max_amount].[br][br]
##
## [color=orange]NOTE[/color]: If [enum _behaviors] is set to [param default], no changes will occur, even if the percentage is greater than 0.
@export_range(0, 30) var change_percent: float = 0

## The number of seconds until an automatic health change occurs.[br][br]
##
## [color=orange]NOTE[/color]: The automatic health change is controlled by a change timer.
@export_range(0.15, 5) var change_in_seconds: float = 0.15

## The number of seconds to pause the automatic health change.[br][br]
##
## [color=orange]NOTE[/color]: The pause in automatic health change is controlled by a pause timer.
@export_range(0.15, 5) var pause_in_seconds: float = 1

@export_category("Switches")
## Enable this if health can be decreased.
@export var damageable: bool = true

## Enable this if health can be increased.
@export var healable: bool = true

## Enable this if health can be increased when the amount is already at or below 0.
@export var revivable: bool = false

@export_category("Emitters")
## Enable this to emit the [signal damage] signal
@export var emit_damage: bool = true

## Enable this to emit the [signal death] signal
@export var emit_death: bool = true

## Enable this to emit the [signal heal] signal
@export var emit_heal: bool = false

## Enable this to emit the [signal revive] signal
@export var emit_revive: bool = false

var _show_timer: Timer
var _change_timer: Timer
var _pause_timer: Timer
var _current_change_in_seconds: float = 0

## Returns the object's class name, as a [String]. This function overrides the [Object]'s built-in function [method Object.get_class].
func get_class() -> String: return "Health"

func _ready():
	if Engine.is_editor_hint(): return
	_create_show_timer()
	_create_change_timer()
	_create_pause_timer()
	sync_healthbar()

func _process(_delta):
	if Engine.is_editor_hint(): return
	_check_behavior()

func _check_behavior():
	if behavior == _behaviors.default: return
	if _change_timer.paused: return
	if change_percent <= 0: return
	# Guard against lower change rate
	if change_in_seconds < 0.15:
		printerr("'change_in_seconds' cannot fall below 0.15")
		return
	if _current_change_in_seconds == change_in_seconds: return
	_change_timer.wait_time = change_in_seconds
	if change_in_seconds > 0 and _change_timer.is_stopped():
		_change_timer.start()
	elif change_in_seconds <= 0 and !_change_timer.is_stopped():
		_change_timer.stop()
	_current_change_in_seconds = change_in_seconds

func _create_show_timer():
	_show_timer = Timer.new()
	add_child(_show_timer)
	_show_timer.one_shot = true
	_show_timer.timeout.connect(_on_show_timer_timeout)

func _on_show_timer_timeout():
	if hide_in_seconds > 0:
		if texture_progress != null: texture_progress.visible = false
		if progress != null: progress.visible = false
	else:
		if texture_progress != null: texture_progress.visible = true
		if progress != null: progress.visible = true

func _create_change_timer():
	_change_timer = Timer.new()
	add_child(_change_timer)
	_change_timer.one_shot = false
	_change_timer.timeout.connect(_on_change_timer_timeout)
	_check_behavior()
	
func _on_change_timer_timeout():
	if behavior == _behaviors.default: return
	var percent = (change_percent / 100) * max_amount
	if behavior == _behaviors.auto_increase and amount < max_amount:
		update_amount(percent)
	elif behavior == _behaviors.auto_decrease and amount > 0:
		update_amount(-percent)

func _create_pause_timer():
	_pause_timer = Timer.new()
	add_child(_pause_timer)
	_pause_timer.one_shot = false
	_pause_timer.timeout.connect(_on_pause_timer_timeout)

func _on_pause_timer_timeout():
	_change_timer.paused = false

## A function to check if the automatic health change is paused.
func is_behavior_paused() -> bool:
	return _change_timer.paused

## A function to pause the automatic health change for a specified number of seconds using the [member pause_in_seconds] value.[br][br]
##
## [color=orange]NOTE[/color]: Changing the behavior to default will not stop the pause timer. However, if the behavior is restarted while the pause timer is active, it will likely delay the start of the change timer until the pause timer expires.
func pause_behavior():
	if _change_timer.is_stopped(): return
	_change_timer.paused = true

## A function to synchronize the health bar with the current health values.
func sync_healthbar():
	if texture_progress != null:
		texture_progress.max_value = max_amount
		texture_progress.value = amount
		if hide_in_seconds > 0:
			texture_progress.visible = false
		else:
			texture_progress.visible = true

	if progress != null:
		progress.max_value = max_amount
		progress.value = amount
		if hide_in_seconds > 0:
			progress.visible = false
		else:
			progress.visible = true

## A function that updates the health amount and emits signals based on the amount.
func update_amount(_amount: float):
	if _amount == 0: return
	if (amount <= 0 and _amount > 0) and !revivable: return
	if _amount < 0 and !damageable: return
	if _amount > 0 and !healable: return
	
	var old_amount = amount
	
	# check if exceeds maximum health
	if _amount > max_amount || (amount + _amount) > max_amount:
		amount = max_amount # set to maximum
	else:
		amount += _amount # add to health
	
	# ensure our health is 0 to avoid missing health amount when revived
	if amount < 0: amount = 0;
	
	# emit the local signal
	emit_signal("update", get_parent(), _amount, amount)
	
	# emit the global signal if available
	var global_health = get_tree().root.get_node("/root/GlobalHealth")
	if global_health and !Engine.is_editor_hint():
		global_health.emit_signal("update", get_parent(), _amount, amount)

	if texture_progress != null or progress != null:
		if texture_progress != null:
			texture_progress.visible = true
			texture_progress.value = amount
		
		if progress != null:
			progress.visible = true
			progress.value = amount
		
		if hide_in_seconds > 0:
			_show_timer.wait_time = hide_in_seconds
			_show_timer.start()

	if _amount > 0:
		if emit_heal: emit_signal("heal", _amount, amount)
		if old_amount == 0:
			if emit_revive: emit_signal("revive", _amount, amount)
		return
	elif _amount < 0:
		if emit_damage: emit_signal("damage", _amount, amount)

	if amount == 0:
		if emit_death: emit_signal("death")
