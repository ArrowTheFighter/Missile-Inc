extends Base_Control

var control_1_value := 0.0
var control_2_value := 0.0

var target_value := 0.0

@export var dampening := 0.1

func _process(delta: float) -> void:
	if abs(control_value - target_value) > 0.0002:
		var new_value = lerp(control_value,target_value,dampening)
		set_control_value(new_value)
	pass

func input_control_1(value : float):
	control_1_value = value / 2
	target_value = control_1_value + control_2_value
	pass
	
func input_control_2(value : float):
	control_2_value = value / 2
	target_value = control_1_value + control_2_value
	pass
