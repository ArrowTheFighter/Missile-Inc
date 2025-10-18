extends Node3D

@export var offset_target:Marker3D
@export var offset_vector : Vector3

@export_category("Control Assignments")
@export var gun_fire_controls : Array[Base_Control]
@export var move_crosshair_x_controls : Array[Base_Control]
@export var move_crosshair_y_controls : Array[Base_Control]

func _ready() -> void:
	_hide_controls()
	setup_control_signals()
	_move_in_controls()


func setup_control_signals():
	var scene_refrence_node
	for child in get_tree().root.get_children():
		if child is LevelReference:
			scene_refrence_node = child as LevelReference
			
	for node in gun_fire_controls:
		node.onValueChanged.connect(scene_refrence_node.gun_node.Fire_Gun)
		
	for node in move_crosshair_x_controls:
		print("conecting x crosshair controls signals")
		node.onValueChanged.connect(scene_refrence_node.crosshair_node.Set_X_Position)
		
	for node in move_crosshair_y_controls:
		node.onValueChanged.connect(scene_refrence_node.crosshair_node.Set_Y_Position)
	pass

func _hide_controls() -> void:
	#var offset = offset_target.global_position
	for child in get_children():
		child.global_position += offset_vector

func _move_in_controls() -> void:
	var offset = offset_vector
	var tween = get_tree().create_tween()
	for child in get_children():
		tween.tween_property(child, "global_position", child.global_position - offset, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_start_pressed() -> void:
	_move_in_controls()
