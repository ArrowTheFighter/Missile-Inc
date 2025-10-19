extends Node

signal level_deloaded

@export var starting_level := 0
var current_level = 0
@export var Levels : Array[LevelData]

@export var spawner : EnemySpawnerScript
var current_controls:ControlsSpawnHandler

func _ready() -> void:
	current_level = starting_level

func start_level():
	if Levels.size() > current_level:
		spawner.Wave_Data = Levels[current_level].wave_data
		$LevelBackgroundMusic.stop()
		$LevelBackgroundMusic.stream = null
		if Levels[current_level].background_music:
			$LevelBackgroundMusic.stream = Levels[current_level].background_music
		if(current_controls != null):
			current_controls.queue_free()
			
		print("Spawning controls")
		var instanced_controls = Levels[current_level].controls_scene.instantiate()
		get_tree().root.add_child(instanced_controls)
		current_controls = instanced_controls
		await current_controls.controls_moved_in
		if $LevelBackgroundMusic.stream:
			$LevelBackgroundMusic.play()
		spawner.start_wave()

func deload_level()->void:
	current_controls.move_out_controls()
	$LevelBackgroundMusic.stop()
	$LevelBackgroundMusic.stream = null
	await current_controls.controls_moved_out
	level_deloaded.emit()

func increase_level():
	current_level += 1
