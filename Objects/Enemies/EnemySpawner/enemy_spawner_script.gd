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
var last_spawn_pos

signal match_ended

func start_wave() -> void:
	print("Match started")
	timer.timeout.connect(set_wave_timeout)
	current_wave = 0
	if Wave_Data != null:
		timer.wait_time = Wave_Data.initial_delay
	timer.start()
	pass

func set_wave_timeout():
	if Wave_Data != null and Wave_Data.Wave_Section.size() > current_wave:
		print("Starting new wave")
		timer.wait_time = Wave_Data.Wave_Section[current_wave].SpawnDelay
		if timer.timeout.is_connected(set_wave_timeout):
			timer.timeout.disconnect(set_wave_timeout)
		if !timer.timeout.is_connected(spawn_enemy):
			timer.timeout.connect(spawn_enemy)
	#wave ended
	else:
		wait_for_enemies_to_die()
		timer.stop()
		if timer.timeout.is_connected(set_wave_timeout):
			timer.timeout.disconnect(set_wave_timeout)

func wait_for_enemies_to_die():
	while(Spawned_Enemies.size() > 0):
		await get_tree().create_timer(0.1).timeout
	
	match_ended.emit()
	print("Match finished")

func spawn_enemy():
	
	var shape = Spawn_Zone.shape
	if(shape is BoxShape3D):
		var spawn_pos = get_random_spawn_pos()
		
		var enemy_scene = Wave_Data.Wave_Section[current_wave].EnemyScene
		var enemy_instance = enemy_scene.instantiate()
		add_child(enemy_instance)
		
		if Wave_Data.Wave_Section[current_wave].EnemySpeed != 0.0:
			enemy_instance.speed = Wave_Data.Wave_Section[current_wave].EnemySpeed
			
		if Wave_Data.Wave_Section[current_wave].EnemyHealth != 0:
			enemy_instance.health = Wave_Data.Wave_Section[current_wave].EnemyHealth
		
		
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
		
func get_random_spawn_pos():
	var i = 0
	var spawn_pos
	while i < 20:
		var shape = Spawn_Zone.shape
		var half_size = shape.size.x / 2.0
		var random_spawn_offset = randf_range(-half_size,half_size)
		spawn_pos = Spawn_Zone.global_position + Vector3.RIGHT * random_spawn_offset
		if(last_spawn_pos == null):
			last_spawn_pos = spawn_pos
			break
		elif abs(last_spawn_pos.x - spawn_pos.x) > 0.5:
			last_spawn_pos = spawn_pos
			break
		i += 1
	return spawn_pos

func kill_spawned_enemies():
	for i in Spawned_Enemies:
		print('killing enemies')
		i.queue_free()
	Spawned_Enemies = []
	timer.stop()
	for dict in timer.timeout.get_connections():
		timer.timeout.disconnect(dict.callable)
	
	
