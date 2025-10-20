extends Node3D


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			for child in get_children():
				if child is LevelSelector:
					child.move_to_spawn()
					await get_tree().create_timer(.2).timeout
