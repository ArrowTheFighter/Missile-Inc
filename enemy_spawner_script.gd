extends Node3D

@export var enemy_scene : PackedScene
@export var Spawn_Zone : CollisionShape3D
@export var spawn_delay := 2.0
@export var timer : Timer

func _ready() -> void:
	timer.wait_time = spawn_delay

func spawn_enemy():
	var shape = Spawn_Zone.shape
	if(shape is BoxShape3D):
		var half_size = shape.size.x / 2.0
		var random_spawn_offset = randf_range(-half_size,half_size)
		var spawn_pos = Spawn_Zone.global_position + Vector3.RIGHT * random_spawn_offset
		
		var enemy_instance = enemy_scene.instantiate()
		get_tree().root.add_child(enemy_instance)
		
		enemy_instance.global_position = spawn_pos
		
