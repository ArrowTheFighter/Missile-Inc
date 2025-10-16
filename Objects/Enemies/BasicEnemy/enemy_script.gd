class_name EnemyScript
extends Node3D

@export var health := 1
@export var speed := 1.0
@export var damage_strength := 1
@export var Area : Area3D
@export_category("Death Particle")
@export var death_particle : PackedScene
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
	if death_particle != null:
		var instanced_death_particle = death_particle.instantiate()
		get_tree().root.add_child(instanced_death_particle)
		instanced_death_particle.global_position = global_position
	queue_free()
