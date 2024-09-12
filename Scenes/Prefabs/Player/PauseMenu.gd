extends Control


func _ready() -> void:
	hide()


func _on_resume_button_pressed():
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_quit_button_pressed():
	get_tree().quit()
