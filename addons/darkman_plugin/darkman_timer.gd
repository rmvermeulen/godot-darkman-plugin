@tool extends Timer

@export var shell := "nu"
@export var cmd := "darkman get"
@export var interval := 3:
	set(value):
		interval = value
		#prints("interval =", interval)
		if is_inside_tree():
			start(value)
@export var fallback_mode := "Light"
@export var dark_mode_theme := "Dark"
@export var light_mode_theme := "Light"

var resolved_theme: String


func _ready() -> void:
	one_shot = false
	timeout.connect(_on_timeout)
	_get_and_apply_mode()
	start(interval)
	#prints("darkman_timer ready!")


func _on_timeout() -> void:
	_get_and_apply_mode()


func _get_and_apply_mode():
	#prints("_get_and_apply_mode")
	var output := get_darkman_output(shell, cmd)
	#prints("output: [%s]" % output)
	if output:
		resolved_theme = output
	else: match fallback_mode:
		"Light": resolved_theme = light_mode_theme
		"Dark": resolved_theme = dark_mode_theme
	#prints("resolved theme: [%s]" % resolved_theme)
	apply_theme_mode(resolved_theme)


func _fallback_theme() -> String:
	if fallback_mode == "Light":
		return light_mode_theme
	return dark_mode_theme


static func apply_theme_mode(theme_mode: String):
	if not Engine.is_editor_hint(): return
	var settings = EditorInterface.get_editor_settings()
	var color_preset = "interface/theme/color_preset"
	var current_value = settings.get_setting(color_preset)
	if theme_mode != current_value:
		settings.set_setting(color_preset, theme_mode)


static func get_darkman_output(shell: String, cmd: String) -> String:
	var output := []
	var exit_code := OS.execute(shell, ['-c', cmd], output)
	if exit_code == OK:
		return output[0].strip_edges().capitalize()
	printerr("unexpected output!", {
		"command": [shell, '-c', cmd],
		"exit_code": exit_code,
		"output": output
	})
	return ""
