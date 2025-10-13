extends Node3D

@export var health := 1
@export var speed := 1.0

func _process(delta: float) -> void:
	translate(Vector3.DOWN * speed * delta)

func take_damage(amount : int):
	health -= amount
	if(health <= 0):
		queue_free()
	pass
