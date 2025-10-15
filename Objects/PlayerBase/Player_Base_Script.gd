extends Node3D

var health := 5

func take_damage(amount : int):
	health -= 1
	if health == 0:
		print("we died")
		queue_free()
	pass
