extends Control

@onready var pause_menu = $"../PauseMenu"


func _process(_delta: float) -> void:
	visible = not pause_menu.visible
