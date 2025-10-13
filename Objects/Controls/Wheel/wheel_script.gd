extends Node3D

var selected := false
var control_value := 0.0
var up_vector
var direction_to_mouse
var last_signed_angle := 0.0
var angle_offset := 0.0
var last_drag_angle := 0.0
@export var current_rotation := TAU  # In radians
var min_rotation := 0.0
var max_rotation := TAU  # TAU == 2 * PI (360 degrees)

signal onValueChanged(float)

func _enter_tree() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.pressed and selected:
			selected = false
	if event is InputEventMouseMotion:
		if(selected):
			calculate_new_mouse_angle()
			#angle_offset = new_angle

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			print("Left clicked object")
			var obj_screen_pos = camera.unproject_position(global_transform.origin)
			var mouse_pos = get_viewport().get_mouse_position()
			var mouse_vec = (mouse_pos - obj_screen_pos).normalized()

			# This becomes our base angle for rotation
			last_drag_angle = atan2(mouse_vec.y, mouse_vec.x)
			selected = true
			
	pass # Replace with function body.
	
func calculate_new_mouse_angle():
	var camera = get_viewport().get_camera_3d()
	var obj_screen_pos = camera.unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_vec = (mouse_pos - obj_screen_pos).normalized()

	var current_angle = atan2(mouse_vec.y, mouse_vec.x)
	var delta_angle = current_angle - last_drag_angle
	last_drag_angle = current_angle

	# Normalize the delta to prevent large jumps when wrapping
	delta_angle = -wrapf(delta_angle, -PI, PI)

	# Clamp the rotation within [0, 2π]
	var new_rotation = current_rotation + delta_angle
	new_rotation = clamp(new_rotation, min_rotation, max_rotation)

	# Only apply rotation if clamped result is different
	var actual_delta = new_rotation - current_rotation
	if abs(actual_delta) > 0.0001:
		rotate_object_local(Vector3(0, 0, 1), actual_delta)
		current_rotation = new_rotation
		print(snappedf(inverse_lerp(TAU,0,current_rotation),0.01))
		onValueChanged.emit(snappedf(inverse_lerp(TAU,0,current_rotation),0.01))
	
func _calculate_signed_angle() -> float:
	var camera = get_viewport().get_camera_3d()
	var obj_screen_pos = camera.unproject_position(global_transform.origin)

	var up_world = global_transform.basis.y.normalized()
	var up_point_world = global_transform.origin + up_world
	var up_screen_pos = camera.unproject_position(up_point_world)
	var up_2d = (up_screen_pos - obj_screen_pos).normalized()

	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_vec = (mouse_pos - obj_screen_pos).normalized()

	var angle = up_2d.angle_to(mouse_vec)
	var cross = up_2d.x * mouse_vec.y - up_2d.y * mouse_vec.x
	var sign = sign(cross)
	var signed_angle = angle * sign

	return signed_angle
