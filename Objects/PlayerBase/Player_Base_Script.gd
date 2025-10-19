extends Node3D

@export var health := 5
var start_health : int
@export_category("Base Color")
@export var mesh : MeshInstance3D
@export var max_health_color : Color
@export var min_health_color : Color

signal base_destroyed

func _ready() -> void:
	start_health = health
	
	
func damage_base(amount : int):
	health -= 1
	if mesh != null:
		var mat = mesh.get_active_material(0)
		if mat is StandardMaterial3D:
			mat = mat.duplicate()
			mat.albedo_color = max_health_color.lerp(min_health_color, 1.0 - float(health) / float(start_health)  )
			mesh.set_surface_override_material(0,mat)
			
	if health == 0:
		base_destroyed.emit()
		queue_free()
	pass
