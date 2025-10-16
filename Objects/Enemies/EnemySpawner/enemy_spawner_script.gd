class_name EnemySpawnerScript
extends Node3D

@export_category("Wave Data")
@export var Wave_Data : WaveData
@export_category("Spawner settings")

@export var Spawn_Zone : CollisionShape3D
@export var timer : Timer

var Spawned_Enemies : Array[EnemyScript]
var tracked_enemies := 0

var current_wave := 0
var enemies_spawned := 0

signal match_ended

func _enter_tree() -> void:
	print("Match started")
	timer.timeout.connect(set_wave_timeout)
	if Wave_Data != null:
		timer.wait_time = Wave_Data.initial_delay

func _ready() -> void:
	#print("Match started")
	#timer.timeout.connect(set_wave_timeout)
	#if Wave_Data != null:
		#timer.wait_time = Wave_Data.initial_delay
	pass

func set_wave_timeout():
	if Wave_Data != null and Wave_Data.Wave_Section.size() > current_wave:
		print("Starting new wave")
		timer.wait_time = Wave_Data.Wave_Section[current_wave].SpawnDelay
		if timer.timeout.is_connected(set_wave_timeout):
			timer.timeout.disconnect(set_wave_timeout)
		timer.timeout.connect(spawn_enemy)
	#wave ended
	else:
		wait_for_enemies_to_die()
		if timer.timeout.is_connected(set_wave_timeout):
			timer.timeout.disconnect(set_wave_timeout)

func wait_for_enemies_to_die():
	while(Spawned_Enemies.size() > 0):
		print("waiting for enemies to die - " + str(Spawned_Enemies.size()))
		await get_tree().create_timer(0.1).timeout
	
	match_ended.emit()
	print("Match finished")

func spawn_enemy():
	
	print("Spawning enemy")
	var shape = Spawn_Zone.shape
	if(shape is BoxShape3D):
		var half_size = shape.size.x / 2.0
		var random_spawn_offset = randf_range(-half_size,half_size)
		var spawn_pos = Spawn_Zone.global_position + Vector3.RIGHT * random_spawn_offset
		
		var enemy_scene = Wave_Data.Wave_Section[current_wave].EnemyScene
		var enemy_instance = enemy_scene.instantiate()
		get_tree().root.add_child(enemy_instance)
		
		
		if enemy_instance is EnemyScript:
			enemy_instance.spawner_refrence = self
			Spawned_Enemies.append(enemy_instance)
		
		enemy_instance.global_position = spawn_pos
		enemies_spawned += 1
			
		if enemies_spawned >= Wave_Data.Wave_Section[current_wave].SpawnCount:
			enemies_spawned = 0
			current_wave += 1
			timer.timeout.disconnect(spawn_enemy)
			set_wave_timeout()
		
