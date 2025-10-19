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
