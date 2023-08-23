class_name TobeScene
extends Node3D
## Tobe Scene decides what scene is to be seen and when we get to see it

@export var starting_scene: int = 0
@export var scenes: Array[PackedScene]

var _current_scene_elapsed: float
@onready var _current_scene_idx: int = starting_scene - 1
var _scenes: Array[Node]

func _ready() -> void:
	assert(not scenes.is_empty(), "Tobe Scene needs at least one scene")
	for scene in scenes:
		_scenes.append(scene.instantiate())

func _process(delta: float) -> void:
	_current_scene_elapsed += delta
	var scene = _current_scene()
	if not scene or _current_scene_elapsed > scene.length:
		_scene_transition(1, false)

func _input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return # Don't allow seeking in release

	var keyEvent = event as InputEventKey
	if not keyEvent or not keyEvent.pressed:
		return

	if keyEvent.keycode == KEY_LEFT:
		_scene_transition(-1, true)
	if keyEvent.keycode == KEY_RIGHT:
		_scene_transition(1, true)

func _current_scene() -> Scene:
	return get_node_or_null("Scene") as Scene

func _scene_transition(jump: int, reset_time: bool) -> void:
	# Remove current scene
	var scene = _current_scene()
	if scene:
		_current_scene_elapsed = 0 if reset_time else _current_scene_elapsed - scene.length
		remove_child(scene)
		scene.queue_free()

	# Check if we've played everything
	_current_scene_idx = max(_current_scene_idx + jump, 0)
	if _current_scene_idx >= _scenes.size():
		get_tree().quit()
		return

	# Instantiate new scene
	scene = _scenes[_current_scene_idx] as Scene
	add_child(scene.duplicate())
