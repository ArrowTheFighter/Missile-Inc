class_name EnemyScript
extends Node3D

@export var health := 1
@export var speed := 1.0
@export var damage_strength := 1
@export var Area : Area3D
var spawner_refrence : EnemySpawnerScript

func _ready() -> void:
	Area.area_entered.connect(enter_area)

func _process(delta: float) -> void:
	translate(Vector3.DOWN * speed * delta)

func take_damage(amount : int):
	health -= amount
	if(health <= 0):
		die()
	pass
	
func enter_area(area: Area3D):
	if area.get_parent() != null:
		if area.get_parent().has_method("damage_base"):
			area.get_parent().call("damage_base",damage_strength)
			die()
	pass
	
func die():
	spawner_refrence.Spawned_Enemies.erase(self)
	queue_free()
