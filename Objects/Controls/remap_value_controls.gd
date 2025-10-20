extends Base_Control

@export var remamped_low_value := 0.0
@export var remamped_high_value := 1.0

func control_input(value : float):
	var new_value = lerp(remamped_low_value,remamped_high_value,value)
	set_control_value(new_value)
	pass
