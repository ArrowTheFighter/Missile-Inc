extends Node3D

@export var health := 5

func damage_base(amount : int):
	health -= 1
	if health == 0:
		print("we died")
		queue_free()
	pass
