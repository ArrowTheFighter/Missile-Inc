extends Base_Control

@export var toggle_button := false
@export var start_pressed := false

@export var mesh : MeshInstance3D 

@onready var pad_origin_pos:Vector3 = $ButtonPad.position
const pad_push_offset:Vector3 = Vector3(0,0, -0.15)

func _ready() -> void:
	super._ready()
	if start_pressed and toggle_button:
		set_control_value(1)
		var tween = get_tree().create_tween()
		tween.tween_property($ButtonPad, "position", pad_origin_pos + pad_push_offset, .1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and !event.pressed and selected:
			selected = false
			if !toggle_button:
				set_control_value(0)
				var tween = get_tree().create_tween()
				tween.tween_property($ButtonPad, "position", pad_origin_pos, .1)
			## Set the button color
			#var mat = mesh.get_active_material(0)
			#if mat is StandardMaterial3D:
				#mat = mat.duplicate()
				#mat.albedo_color = Color.html("#008755")
				#mesh.set_surface_override_material(0,mat)
			

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			selected = true
			if !toggle_button:
				set_control_value(1)
				var tween = get_tree().create_tween()
				tween.tween_property($ButtonPad, "position", pad_origin_pos + pad_push_offset, .1)
			else:
				if control_value == 0:
					set_control_value(1)
					var tween = get_tree().create_tween()
					tween.tween_property($ButtonPad, "position", pad_origin_pos + pad_push_offset, .1)
				else:
					set_control_value(0)
					var tween = get_tree().create_tween()
					tween.tween_property($ButtonPad, "position", pad_origin_pos, .1)
				
			#var tween = get_tree().create_tween()
			#tween.tween_property($ButtonPad, "position", pad_origin_pos + pad_push_offset, .1)
			$ButtonSound.play()
			
			# set button color REMOVED
			#var mat = mesh.get_active_material(0)
			#if mat is StandardMaterial3D:
				#mat = mat.duplicate()
				#mat.albedo_color = Color.html("#004126")
				#mesh.set_surface_override_material(0,mat)
