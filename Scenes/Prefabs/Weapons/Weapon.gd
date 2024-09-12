class_name Weapon extends RigidBody3D

@export_category("Weapon Information")
@export var weapon_name: StringName
@export_category("Weapon Sway Settings")
@export var weapon_sway_amount: float = 5.0
@export var weapon_rotation_amount: float = 1.0
@export_category("Weapon Offset Settings")
@export var weapon_position: Vector3
@export var weapon_rotation: Vector3

var can_fire: bool = true


func fire():
	pass


func reload():
	pass


func equip():
	pass


func start_fire_cooldown() -> void:
	pass
