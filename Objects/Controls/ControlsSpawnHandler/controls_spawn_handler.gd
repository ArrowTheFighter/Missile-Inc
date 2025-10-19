class_name ControlsSpawnHandler
extends Node3D

signal controls_moved_in
signal controls_moved_out

@export var offset_target:Marker3D
@export var offset_vector : Vector3

@export_category("Gun settings")
@export var use_crosshair := true
@export var require_reloading := false

@export_category("Control Assignments")
@export var gun_fire_controls : Array[Base_Control]
@export var move_crosshair_x_controls : Array[Base_Control]
@export var move_crosshair_y_controls : Array[Base_Control]
@export var open_ammo_controls : Array[Base_Control]
@export var load_ammo_controls : Array[Base_Control]
@export var remove_empty_ammo_controls: Array[Base_Control]
@export var move_gun_left_right : Array[Base_Control]


func _ready() -> void:
	_hide_controls()
	setup_control_signals()
	_move_in_controls()


func setup_control_signals():
	var scene_refrence_node
	for child in get_tree().root.get_children():
		if child is LevelReference:
			scene_refrence_node = child as LevelReference
			
	scene_refrence_node.gun_node.Use_Crosshair = use_crosshair
	scene_refrence_node.gun_node.Require_Reloading = require_reloading
			
	for node in gun_fire_controls:
		node.onValueChanged.connect(scene_refrence_node.gun_node.Fire_Gun)
		
	for node in move_crosshair_x_controls:
		node.onValueChanged.connect(scene_refrence_node.crosshair_node.Set_X_Position)
		
	for node in move_crosshair_y_controls:
		node.onValueChanged.connect(scene_refrence_node.crosshair_node.Set_Y_Position)
		
	for node in open_ammo_controls:
		node.onValueChanged.connect(scene_refrence_node.gun_node.Open_Ammo_Chamber)
		
	for node in load_ammo_controls:
		node.onValueChanged.connect(scene_refrence_node.gun_node.Load_Ammo)
		
	for node in remove_empty_ammo_controls:
		node.onValueChanged.connect(scene_refrence_node.gun_node.Remove_Empty_Ammo)
		
	for node in move_gun_left_right:
		node.onValueChanged.connect(scene_refrence_node.gun_node.Move_Gun)
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
	await tween.finished
	controls_moved_in.emit()

func move_out_controls() -> void:
	var offset = offset_vector
	var tween = get_tree().create_tween()
	for child in get_children():
		tween.tween_property(child, "global_position", child.global_position + offset, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	controls_moved_out.emit()

func _on_start_pressed() -> void:
	_move_in_controls()
