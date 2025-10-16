extends CanvasLayer

@export var end_match_buttons : Array[Control]
# Called when the node enters the scene tree for the first time.
func show_match_end_buttons():
	for i in end_match_buttons:
		i.visible = true
	
