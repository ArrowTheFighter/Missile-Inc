extends Node3D

@export var offset_target:Marker3D

func _ready() -> void:
	_hide_controls()

func _hide_controls() -> void:
	var offset = offset_target.global_position
	for child in get_children():
		child.global_position += offset

func _move_in_controls() -> void:
	var offset = offset_target.global_position
	var tween = get_tree().create_tween()
	for child in get_children():
		tween.tween_property(child, "global_position", child.global_position - offset, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_start_pressed() -> void:
	_move_in_controls()
