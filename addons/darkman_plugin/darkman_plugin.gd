@tool
extends EditorPlugin

var timer_scene := load("res://addons/darkman_plugin/darkman_timer.tscn")
var timer = null

const ROOT := "darkman_plugin"
const PROPS := {
	# Which shell to use when calling `darkman`
	"shell": ["sh", {
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM_SUGGESTION,
		"hint_string": "sh,bash,zsh,pwsh,fish,nu",
	}],
	# If true, removes `darkman_plugin/*` from EditorSettings when the plugin is disabled
	"remove_editor_settings": [true, { "type": TYPE_BOOL }],
	# The command to run to get darkman's output
	"cmd": ["darkman get", { "type": TYPE_STRING }],
	# The string template to use for the button text
	"template": ["Theme: %s", { "type": TYPE_STRING }],
	# Interval in seconds in-between checks
	"interval": [3, { "type": TYPE_INT }],
	# The mode to use if anything goes wrong
	"fallback_mode": ["Light", {
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Light,Dark"
	}],
	# Which theme to use while the mode is 'Dark'
	"dark_mode_theme": ["Dark", { "type": TYPE_STRING }],
	# Which theme to use while the mode is 'Light'
	"light_mode_theme": ["Light", { "type": TYPE_STRING }],
}

const old_settings := [
	"silent", "template","fallback", "dark_mode", "light_mode"
]


static func get_setting_name(key: String) -> String:
	return "%s/%s" % [ROOT, key]


func _enable_plugin() -> void:
	pass


func _disable_plugin() -> void:
	pass


func _enter_tree() -> void:
	timer = timer_scene.instantiate()
	add_child(timer)
	_update_settings()
	var settings := EditorInterface.get_editor_settings()
	settings.settings_changed.connect(_update_settings)
	for key in PROPS.keys():
		var items = PROPS[key]
		var value = items[0]
		var info = items[1].duplicate()
		info.name = get_setting_name(key)
		if settings.has_setting(info.name):
			continue
		settings.set(info.name, value)
		settings.add_property_info(info)
	for key in old_settings:
		if settings.has_setting(get_setting_name(key)):
			settings.erase(get_setting_name(key))


func _exit_tree() -> void:
	var settings := EditorInterface.get_editor_settings()
	if settings.settings_changed.is_connected(_update_settings):
		settings.settings_changed.disconnect(_update_settings)
	timer.stop()
	timer.queue_free()
	timer = null
	var key := get_setting_name("remove_editor_settings")
	var remove_editor_settings := settings.has_setting(key) && settings.get_setting(key) as bool
	if remove_editor_settings:
		for setting in PROPS.keys():
			settings.erase(get_setting_name(setting))


func _update_settings():
	var settings := EditorInterface.get_editor_settings()
	var setting_names := [
			"shell", "cmd", "interval",
			"fallback_mode", "dark_mode_theme", "light_mode_theme"
		].map(get_setting_name)
	for key in setting_names:
		var setting := settings.get(key)
		if timer.get(key) != setting:
			#prints('timer set setting:', key, setting)
			timer.set(key, setting)
