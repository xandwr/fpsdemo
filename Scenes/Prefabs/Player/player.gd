extends CharacterBody3D

@export var movement_component: PlayerMovement
@export var camera_component: PlayerCamera
@onready var player_manager = $PlayerManager

@onready var head = $Head
@onready var camera = $Head/Camera3D


func _ready() -> void:
	movement_component.init(self)
	camera_component.init(self)
	player_manager.init(self)

func _physics_process(delta: float) -> void:
	movement_component.process_movement(delta)

func _unhandled_input(event: InputEvent) -> void:
	camera_component.process_look(event)

func _input(event: InputEvent) -> void:
	player_manager.process_input(event)
