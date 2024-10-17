@tool
extends EditorPlugin

# scripts
const GLOBAL_HEALTH_SCRIPT = "res://addons/jbs_health_node/jbs_global_health.gd"
const HEALTH_SCRIPT = "res://addons/jbs_health_node/jbs_health.gd"
const HEALTH_GROWLER_SCRIPT = "res://addons/jbs_health_node/controls/jbs_health_growler.gd"

# icons
const HEALTH_ICON = "res://addons/jbs_health_node/jbs_health_node.png"
const HEALTH_GROWLER_ICON = "res://addons/jbs_health_node/controls/jbs_health_growler.png"

var script_dictionary: Dictionary = {
	"GlobalHealth": GLOBAL_HEALTH_SCRIPT,
	"Health" : HEALTH_SCRIPT,
	"HealthGrowler": HEALTH_GROWLER_SCRIPT
}

func _enter_tree() -> void:
	add_autoload_singleton("GlobalHealth", GLOBAL_HEALTH_SCRIPT)
	add_custom_type("Health", "Node", preload(HEALTH_SCRIPT), preload(HEALTH_ICON))
	add_custom_type("HealthGrowler", "Control", preload(HEALTH_GROWLER_SCRIPT), preload(HEALTH_GROWLER_ICON))
	
	_reload_scripts()
	
func _exit_tree() -> void:
	remove_custom_type("HealthGrowler")
	remove_custom_type("Health")
	remove_autoload_singleton("GlobalHealth")

# Workaround to save script and force reload/refresh of script plugin documentations
func _reload_scripts() -> void:
	for key in script_dictionary.keys():
		var script_path = script_dictionary.get(key)
		var script = ResourceLoader.load(script_path)
		if script:
			ResourceSaver.save(script, script_path)
