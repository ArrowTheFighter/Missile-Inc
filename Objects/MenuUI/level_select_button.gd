class_name LevelButton
extends Button

@export var level_id := 0
signal level_button_pressed(int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(level_button_pressed_func)
	pass # Replace with function body.

func level_button_pressed_func():
	level_button_pressed.emit(level_id)
	pass
