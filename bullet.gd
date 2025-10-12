extends Node3D

@export var speed := 2.0

func _enter_tree() -> void:
	print("bullet entered tree")

func _process(delta: float) -> void:
	global_translate(transform.basis.y * speed * delta)
