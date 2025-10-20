extends Base_Control

@export var max_time := 1.0
var currrent_time = 0.0
var reverse := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	if !reverse:
		currrent_time += delta
	else:
		currrent_time -= delta
		
	if currrent_time > max_time / 2:
		reverse = true
	elif currrent_time < 0:
		reverse = false
	set_control_value(currrent_time / (max_time / 2))
	pass
