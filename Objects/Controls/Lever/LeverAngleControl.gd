extends Node3D

func _physics_process(delta: float) -> void:
	rotation.x = -($"../../../Area3D2".position - position).y
	#look_at($"../../../Area3D2".global_position, Vector3.BACK, true)
