extends Node

@export var starting_level := 0
var current_level = 0
@export var Levels : Array[LevelData]

@export var spawner : EnemySpawnerScript
var current_controls

func _ready() -> void:
	current_level = starting_level

func start_level():
	if Levels.size() > current_level:
		spawner.Wave_Data = Levels[current_level].wave_data
		spawner.start_wave()
		if(current_controls != null):
			current_controls.queue_free()
			
		print("Spawning controls")
		var instanced_controls = Levels[current_level].controls_scene.instantiate()
		get_tree().root.add_child(instanced_controls)
		current_controls = instanced_controls
	
	
func increase_level():
	current_level += 1
