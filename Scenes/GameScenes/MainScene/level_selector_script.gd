extends Node3D

signal level_selected(index:int)

@export var level_index := 0

var orig_transform : Transform3D
var offset_dir := Vector3(0,.5,0)

func _ready() -> void:
	orig_transform = global_transform

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			level_selected.emit(level_index)

func _on_area_3d_mouse_entered() -> void:
	$PickupSound.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", global_position + offset_dir, .1).set_ease(Tween.EASE_OUT)

func _on_area_3d_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", orig_transform.origin, .1).set_ease(Tween.EASE_OUT)
