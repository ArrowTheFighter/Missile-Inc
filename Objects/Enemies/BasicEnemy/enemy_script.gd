class_name EnemyScript
extends Node3D

@export var health := 1
@export var speed := 1.0
@export var damage_strength := 1
@export var Area : Area3D
@export var death_sound_stream:AudioStream
@export_category("Death Particle")
@export var death_particle : PackedScene
var spawner_refrence : EnemySpawnerScript

var death_sound:AudioStreamPlayer

func _ready() -> void:
	Area.area_entered.connect(enter_area)
	_prepare_death_sound()

func _process(delta: float) -> void:
	translate(Vector3.DOWN * speed * delta)

func _prepare_death_sound()->void:
	if not death_sound_stream: return
	death_sound = AudioStreamPlayer.new()
	death_sound.stream = death_sound_stream
	death_sound.name = "DeathSound"
	death_sound.volume_db = -20
	get_tree().root.call_deferred("add_child", death_sound)

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
	if death_sound:
		death_sound.play()
		death_sound.finished.connect(func():death_sound.queue_free())
	queue_free()
