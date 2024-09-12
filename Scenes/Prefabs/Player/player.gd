extends CharacterBody3D

@export var movement_component: PlayerMovement
@export var camera_component: PlayerCamera
@onready var player_manager = $PlayerManager

@onready var head = $Head
@onready var camera = $Head/Camera3D

var desired_fov: float


func _ready() -> void:
	movement_component.init(self)
	camera_component.init(self)
	player_manager.init(self)
	desired_fov = camera_component.regular_fov


func _process(delta: float) -> void:
	camera.fov = lerp(camera.fov, desired_fov, 0.05)


func _physics_process(delta: float) -> void:
	movement_component.process_movement(delta)


func _unhandled_input(event: InputEvent) -> void:
	camera_component.process_look(event)


func _input(event: InputEvent) -> void:
	player_manager.process_input(event)
