class_name LevelSelector
extends Node3D

signal level_selected(index:int)

@export var level_index := 0
@export var target_location : Marker3D

var orig_transform : Transform3D
var offset_dir := Vector3(0,.5,0)
var is_active := false

func _ready() -> void:
	orig_transform = global_transform
	if target_location:
		orig_transform = target_location.global_transform
	$Cartridge/Label3D.text = "Level " + str(level_index + 1)
	$Area3D.input_ray_pickable = false
	if level_index == 0:
		move_to_spawn()

func move_to_spawn() -> void:
	if is_active: return
	if target_location:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_transform", target_location.global_transform, .3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		await tween.finished
	$Area3D.input_ray_pickable = true
	is_active = true

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
