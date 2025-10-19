extends Base_Control

var last_drag_angle := 0.0
@export var rotation_damp := 10.0
var rotation_velocity := 0.0
var target_rotation := 0.0
@export var current_rotation := TAU  # In radians
@export_category("Rotations")
@export var max_rotations := 1.0
@export var min_rotations := 0.0
var min_rotation := 0.0
var max_rotation := 0.0  # TAU == 2 * PI (360 degrees)
@onready var target_object = $pipe_end_green2

@export var sound_interval := 1.0
var sound_angle := 0.0

func _ready() -> void:
	super()
	min_rotation = -TAU * min_rotations
	max_rotation = TAU * max_rotations

func _input(event: InputEvent) -> void:
	super(event)
	if event is InputEventMouseMotion:
		if(selected):
			calculate_new_mouse_angle()
			
func _process(delta: float) -> void:
	if abs(target_rotation - current_rotation) > 0.0001:
		current_rotation = lerp_angle(current_rotation, target_rotation, rotation_damp * delta)
		target_object.rotate_object_local(Vector3(0, 1, 0), current_rotation - rotation_velocity)
		rotation_velocity = current_rotation
		var new_value = snappedf(inverse_lerp(max_rotation, min_rotation, current_rotation), 0.0001)
		set_control_value(new_value)
		if sound_angle >= sound_interval:
			sound_angle = 0.0
			$WheelSound.play()

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			var obj_screen_pos = camera.unproject_position(global_transform.origin)
			var mouse_pos = get_viewport().get_mouse_position()
			var mouse_vec = (mouse_pos - obj_screen_pos).normalized()

			last_drag_angle = atan2(mouse_vec.y, mouse_vec.x)
			selected = true
			
	
func calculate_new_mouse_angle():
	var camera = get_viewport().get_camera_3d()
	var obj_screen_pos = camera.unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_vec = (mouse_pos - obj_screen_pos).normalized()

	var current_angle = atan2(mouse_vec.y, mouse_vec.x)
	var delta_angle = current_angle - last_drag_angle
	last_drag_angle = current_angle
	sound_angle += abs(delta_angle)
	print(sound_angle)

	delta_angle = -wrapf(delta_angle, -PI, PI)
	
	target_rotation = clamp(current_rotation + delta_angle, min_rotation, max_rotation)
