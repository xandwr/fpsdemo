class_name PlayerMovement extends Node

@export var walk_speed: float = 4.0
@export var sprint_speed: float = 6.5
@export var acceleration: float = 8.0
@export var deceleration: float = 10.0
@export var jump_force: float = 4.5

var player: CharacterBody3D
var move_velocity: Vector3 = Vector3.ZERO
var is_sprinting: bool = false
var input_direction: Vector2 = Vector2.ZERO


func init(player_ref: CharacterBody3D):
	player = player_ref


func process_movement(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += player.get_gravity().y * delta
	
	if not get_tree().paused:
		is_sprinting = Input.is_action_pressed("Sprint")
		
		if Input.is_action_just_pressed("Jump") and player.is_on_floor():
			player.velocity.y = jump_force
		
		input_direction = Vector2(
			Input.get_action_strength("Right") - Input.get_action_strength("Left"),
			Input.get_action_strength("Backward") - Input.get_action_strength("Forward")
		)
		
		var target_direction = (player.head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
		
		if input_direction != Vector2.ZERO:
			move_velocity.x = lerp(move_velocity.x, target_direction.x * (sprint_speed if is_sprinting else walk_speed), acceleration * delta)
			move_velocity.z = lerp(move_velocity.z, target_direction.z * (sprint_speed if is_sprinting else walk_speed), acceleration * delta)
		else:
			move_velocity.x = lerp(move_velocity.x, 0.0, deceleration * delta)
			move_velocity.z = lerp(move_velocity.z, 0.0, deceleration * delta)
	else:
		move_velocity.x = lerp(move_velocity.x, 0.0, deceleration * delta)
		move_velocity.z = lerp(move_velocity.z, 0.0, deceleration * delta)

	player.velocity.x = move_velocity.x
	player.velocity.z = move_velocity.z

	player.move_and_slide()
