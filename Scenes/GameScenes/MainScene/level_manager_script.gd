extends Node

@export var starting_level := 0
var current_level = 0
@export var Levels : Array[LevelData]

@export var spawner : EnemySpawnerScript

func _ready() -> void:
	current_level = starting_level

func start_level():
	spawner.Wave_Data = Levels[current_level].wave_data
	spawner.start_wave()
	
func increase_level():
	current_level += 1
