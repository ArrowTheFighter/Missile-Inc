extends Node3D
class_name Crosshair
@export var Crosshair_Limit_Shape : CollisionShape3D

signal positionUpdated(position : Vector3)

func _ready() -> void:
	Set_X_Position(0)
	Set_Y_Position(0)

func Set_X_Position(value : float):
	var shape = Crosshair_Limit_Shape.shape
	if  shape is BoxShape3D:
		var half_size_x = shape.size.x / 2.0
		global_position.x = lerp(Crosshair_Limit_Shape.global_position.x - half_size_x,Crosshair_Limit_Shape.global_position.x + half_size_x, value)
		positionUpdated.emit(global_position)
	pass
	
func Set_Y_Position(value : float):
	var shape = Crosshair_Limit_Shape.shape
	if  shape is BoxShape3D:
		var half_size_y = shape.size.y / 2.0
		global_position.y = lerp(Crosshair_Limit_Shape.global_position.y - half_size_y,Crosshair_Limit_Shape.global_position.y + half_size_y, value)
		positionUpdated.emit(global_position)
	pass
