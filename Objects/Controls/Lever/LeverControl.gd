extends Node3D

var selected := false
var control_value := 0.0
@export var maxHeight := 0.0
@export var leverHandle : Area3D

signal onValueChanged(float)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.pressed and selected:
			selected = false
	if event is InputEventMouseMotion:
		if(selected):
			leverHandle.position += Vector3(0,-event.relative.y * 0.0075,0)
			
			leverHandle.position = Vector3(leverHandle.position.x,clampf(leverHandle.position.y,0,maxHeight),leverHandle.position.z)
			control_value = snappedf(inverse_lerp(0,maxHeight,leverHandle.position.y),0.01)
			onValueChanged.emit(control_value)

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			print("Left clicked object")
			selected = true
	
	pass # Replace with function body.
