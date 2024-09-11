class_name PlayerManager extends Node

var player: CharacterBody3D

func init(player_ref: CharacterBody3D):
	player = player_ref
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	update_mouse_lock_state(get_tree().paused)

func update_mouse_lock_state(is_paused: bool) -> void:
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
