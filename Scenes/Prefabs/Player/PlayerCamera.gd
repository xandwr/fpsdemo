class_name PlayerCamera extends Node

@export var sensitivity: float = 0.1
@export var max_look_angle: float = 80.0

var player: CharacterBody3D


func init(player_ref: CharacterBody3D):
	player = player_ref


func process_look(event: InputEvent) -> void:
	if not get_tree().paused:
		if event is InputEventMouseMotion:
			player.head.rotate_y(-event.relative.x * sensitivity * get_process_delta_time())
			player.camera.rotate_x(-event.relative.y * sensitivity * get_process_delta_time())
			player.camera.rotation.x = clamp(player.camera.rotation.x, deg_to_rad(-max_look_angle), deg_to_rad(max_look_angle))
