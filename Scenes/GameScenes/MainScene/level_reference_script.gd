class_name LevelReference
extends Node3D

@export var gun_node : Node3D
@export var crosshair_node : Node3D
@onready var camera:RoomCamera = %RoomCamera

func _on_level_selected(level:int = 0)->void:
	$LevelUI/Button2.HideSelf()
	camera.move_to_tv()
	await camera.move_tv_finished
	$LevelManager.starting_level = level
	$LevelManager.start_level()
	$SubViewport/GamePlayArea/TV_Background.HideBackground()

func _on_turn_off_tv()->void:
	var timer = get_tree().create_timer(1)
	$SubViewport/GamePlayArea/TV_Background.ShowBackground()
	await timer.timeout
	$LevelManager.deload_level()
	await $LevelManager.level_deloaded
	camera.move_to_levels()


func _on_off_button_pressed(value:float) -> void:
	if value > .5:
		_on_turn_off_tv()


func _on_volume_knob_on_value_changed(value: float) -> void:
	var index= AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(index, value)
