extends Control

@onready var velocity_label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/VelocityLabel
@onready var look_dir_label = $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/LookDirLabel


func _process(delta: float) -> void:
	velocity_label.text = "Player Velocity: %s" % get_parent().velocity.snappedf(0.01)
	look_dir_label.text = "Look Direction: %s" % Vector2(
		rad_to_deg(get_parent().camera.global_transform.basis.get_euler().snappedf(0.01)[0]),
		rad_to_deg(get_parent().camera.global_transform.basis.get_euler().snappedf(0.01)[1]),
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Toggle Debug Menu"):
		visible = not visible
