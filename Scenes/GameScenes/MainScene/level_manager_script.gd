extends Node

signal level_deloaded

@export var starting_level := 0
var current_level = 0
@export var Levels : Array[LevelData]

@export var spawner : EnemySpawnerScript
@export var level_cartridges : Array[Node3D]

var current_controls: ControlsSpawnHandler

func _ready() -> void:
	current_level = starting_level

func start_level(level_in:int = -1):
	if level_in > -1: current_level = level_in
	if Levels.size() > current_level:
		spawner.Wave_Data = Levels[current_level].wave_data
		$LevelBackgroundMusic.stop()
		$LevelBackgroundMusic.stream = null
		if Levels[current_level].background_music:
			$LevelBackgroundMusic.volume_db = Levels[current_level].music_volume
			$LevelBackgroundMusic.stream = Levels[current_level].background_music
		if(current_controls != null):
			current_controls.queue_free()
			
		$"../SubViewport/GamePlayArea/Player_Base".respawn_base()	
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
	if current_level < level_cartridges.size():
		level_cartridges[current_level].visible = true
	if current_level >= Levels.size():
		$"../SubViewport/GamePlayArea/GameWinNodes".ShowLevelComplete()
		await get_tree().create_timer(0.01).timeout
		$"../SubViewport/GamePlayArea/LevelCompleteNodes".HideLevelComplete()
