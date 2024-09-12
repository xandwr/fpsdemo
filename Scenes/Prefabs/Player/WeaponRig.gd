extends Node3D

@export var default_weapon_scene: PackedScene

@onready var ammo_label: Label = $"../../../HeadsupDisplay/MarginContainer/HBoxContainer/AmmoLabel"
@onready var player_movement: PlayerMovement = $"../../../PlayerMovement"
@onready var player_camera: PlayerCamera = $"../../../PlayerCamera"
@onready var camera: Camera3D = $".."
@onready var player: CharacterBody3D = $"../../.."

var current_weapon: Weapon = null
var default_weapon_position: Vector3


func _ready():
	if default_weapon_scene:
		equip_weapon(default_weapon_scene)
		default_weapon_position = position


func _process(delta: float) -> void:
	current_weapon.transform.origin = current_weapon.weapon_position
	current_weapon.rotation_degrees = current_weapon.weapon_rotation
	
	if current_weapon:
		if Input.is_action_just_pressed("Fire"):
			current_weapon.fire()
		if Input.is_action_just_pressed("Reload"):
			current_weapon.reload()
		ammo_label.text = "%s/%s" % [current_weapon.ammo_count, current_weapon.max_ammo]
	
	cam_tilt(player_movement.input_direction.x, delta)
	weapon_tilt(player_movement.input_direction.x, player_movement.input_direction.y, player.velocity, delta)
	weapon_sway(delta)


func equip_weapon(weapon_scene : PackedScene):
	if current_weapon:
		current_weapon.queue_free()

	current_weapon = weapon_scene.instantiate() as Weapon
	
	add_child(current_weapon)

	print("Equipped weapon: ", current_weapon)


func cam_tilt(input_x, delta):
	if camera:
		camera.rotation.z = lerp(camera.rotation.z, -input_x * player_camera.camera_tilt, 10.0 * delta)


func weapon_tilt(input_x, input_y, player_velocity, delta):
	rotation.z = lerp(rotation.z, input_x * current_weapon.weapon_rotation_amount, 10.0 * delta)
	rotation.x = clamp(lerp(rotation.x, (-input_y - player_velocity.y) * current_weapon.weapon_rotation_amount, 10.0 * delta), -0.1, 0.1)


func weapon_sway(delta):
	player_camera.mouse_input = lerp(player_camera.mouse_input, Vector2.ZERO, 10.0 * delta)
	rotation.x = lerp(rotation.x, player_camera.mouse_input.y * current_weapon.weapon_sway_amount, 10.0 * delta)
	rotation.y = lerp(rotation.y, player_camera.mouse_input.x * current_weapon.weapon_sway_amount, 10.0 * delta)
