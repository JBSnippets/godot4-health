@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("GlobalHealth", "res://addons/jbs_health_node/jbs_global_health.gd")
	add_custom_type("Health", "Node", preload("res://addons/jbs_health_node/jbs_health.gd"), preload("res://addons/jbs_health_node/jbs_health_node.png"))
	add_custom_type("HealthGrowler", "Control", preload("res://addons/jbs_health_node/controls/jbs_health_growler.gd"), preload("res://addons/jbs_health_node/controls/jbs_health_growler.png"))
	
func _exit_tree():
	remove_custom_type("HealthGrowler")
	remove_custom_type("Health")
	remove_autoload_singleton("GlobalHealth")
