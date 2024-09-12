class_name PlayerCamera extends Node

@export var sensitivity: float = 0.1
@export var max_look_angle: float = 80.0
@export var regular_fov: float = 80.0
@export var sprint_fov: float = 90.0

@onready var player_movement: PlayerMovement = $"../PlayerMovement"

var player: CharacterBody3D


func _process(delta: float) -> void:
	if player_movement.input_direction != Vector2.ZERO:
		player.desired_fov = sprint_fov if player_movement.is_sprinting else regular_fov
	else:
		player.desired_fov = regular_fov
	
	if get_tree().paused:
		player.desired_fov = regular_fov


func init(player_ref: CharacterBody3D):
	player = player_ref


func process_look(event: InputEvent) -> void:
	if not get_tree().paused:
		if event is InputEventMouseMotion:
			player.head.rotate_y(-event.relative.x * sensitivity * get_process_delta_time())
			player.camera.rotate_x(-event.relative.y * sensitivity * get_process_delta_time())
			player.camera.rotation.x = clamp(player.camera.rotation.x, deg_to_rad(-max_look_angle), deg_to_rad(max_look_angle))
