extends Base_Control

@export var maxHeight := 1.0
@export var minHeight := 0.0
@export var sound_interval := 0.2
@export var invert := false

const relativ_to_3D := 0.0175

var distance_since_sound := 0.0

func _input(event: InputEvent) -> void:
	super(event)
	
	if event is InputEventMouseMotion:
		if(selected):
			var old_value := control_value
			Input_Area.position += Vector3(0,-event.relative.y * relativ_to_3D ,0)
			var new_position_y := clampf(Input_Area.position.y,minHeight,maxHeight)
			Input_Area.position = Vector3(Input_Area.position.x, new_position_y,Input_Area.position.z)
			var new_value = snappedf(inverse_lerp(minHeight,maxHeight,Input_Area.position.y),0.01)
			if invert:
				new_value = 1 - new_value
			set_control_value(new_value)
			distance_since_sound += abs( old_value - new_value )
			if distance_since_sound >= sound_interval:
				_play_sound()
				distance_since_sound = 0.0

func _play_sound() -> void:
	if not $LeverSound: return
	#if $LeverSound.playing: return
	$LeverSound.play()
