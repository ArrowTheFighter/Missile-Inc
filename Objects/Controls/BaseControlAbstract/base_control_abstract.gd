@abstract class_name Base_Control
extends Node3D

var selected := false
var locked := false
var control_value := 0.0

@export_category("Control Settings")
@export var Input_Area : Area3D
#changes wether setting locked to true locks the control or vise versa
@export var invert_locked := false

signal onValueChanged(float)

func _ready() -> void:
	if Input_Area != null:
		Input_Area.input_event.connect(_on_input_event)

func set_control_value(value : float):
	control_value = value
	onValueChanged.emit(value)

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if locked: return
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			selected = true
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.pressed and selected:
			selected = false
			
func set_locked(value : bool):
	if invert_locked:
		locked = !value
	else:
		locked = value
	
