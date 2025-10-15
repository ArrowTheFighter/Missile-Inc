extends Base_Control

@export var maxHeight := 0.0


func _input(event: InputEvent) -> void:
	super(event)
	
	if event is InputEventMouseMotion:
		if(selected):
			Input_Area.position += Vector3(0,-event.relative.y * 0.0075,0)
			
			Input_Area.position = Vector3(Input_Area.position.x,clampf(Input_Area.position.y,0,maxHeight),Input_Area.position.z)
			var new_value = snappedf(inverse_lerp(0,maxHeight,Input_Area.position.y),0.01)
			set_control_value(new_value)


	
	
	
