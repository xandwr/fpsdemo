class_name PlayerManager extends Node

var player: CharacterBody3D

@onready var pause_menu = $"../PauseMenu"


func init(player_ref: CharacterBody3D):
	player = player_ref
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		toggle_pause()


func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		pause_menu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	else:
		pause_menu.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func update_mouse_lock_state(is_paused: bool) -> void:
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
