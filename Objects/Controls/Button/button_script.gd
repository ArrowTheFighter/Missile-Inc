extends Node3D

var selected := false

signal onValueChanged(float)
@export var mesh : MeshInstance3D 


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.pressed and selected:
			selected = false
			onValueChanged.emit(0)
			var mat = mesh.get_active_material(0)
			if mat is StandardMaterial3D:
				mat = mat.duplicate()
				mat.albedo_color = Color.html("#008755")
				mesh.set_surface_override_material(0,mat)
			

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			onValueChanged.emit(1)
			print("Left clicked object")
			selected = true
			var mat = mesh.get_active_material(0)
			if mat is StandardMaterial3D:
				mat = mat.duplicate()
				mat.albedo_color = Color.html("#004126")
			mesh.set_surface_override_material(0,mat)
	
	pass # Replace with function body.
