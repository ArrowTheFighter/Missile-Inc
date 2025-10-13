extends Node3D

@export var speed := 2.0

func _enter_tree() -> void:
	print("bullet entered tree")

func _process(delta: float) -> void:
	global_translate(transform.basis.y * speed * delta)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent() != null:
		if area.get_parent().has_method("take_damage"):
			area.get_parent().call("take_damage",1)
	pass # Replace with function body.
