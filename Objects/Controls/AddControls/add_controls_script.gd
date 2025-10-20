extends Base_Control

var control_1_value := 0.0
var control_2_value := 0.0

func input_control_1(value : float):
	control_1_value = value / 2
	set_control_value(control_1_value + control_2_value)
	pass
	
func input_control_2(value : float):
	control_2_value = value / 2
	set_control_value(control_1_value + control_2_value)
	pass
