extends Node3D

func _ready() -> void:
	if not OS.is_debug_build():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent) -> void:
	var keyEvent = event as InputEventKey
	if keyEvent and keyEvent.keycode == KEY_ESCAPE:
		get_tree().quit()
