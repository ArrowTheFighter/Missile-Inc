class_name RoomCamera
extends Camera3D

#@export var shake_decay := 5.0         # How quickly shake fades out
#@export var max_offset := 0.2          # Max positional offset (in meters)
#@export var max_rotation := 2.0        # Max rotation offset (in degrees)
#var shake_strength := 0.0              # Current shake intensity
#@onready var original_transform: Transform3D = %CameraTV.transform    # Store camera's base transform

signal move_tv_finished
signal move_levels_finished

@onready var camera_start_transform :Transform3D = %CameraStart.global_transform
@onready var camera_level_transform :Transform3D = %CameraLevels.global_transform
@onready var camera_tv_transform :Transform3D = %CameraTV.global_transform


func _ready() -> void:
	# Save original transform so we can return to it cleanly
	global_transform = camera_start_transform
	move_to_levels()

func move_to_levels()->void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_transform", camera_level_transform, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)\
		.finished.connect(func():move_levels_finished.emit())

func move_to_tv()->void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_transform", camera_tv_transform, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)\
		.finished.connect(func():move_tv_finished.emit())

#func _process(delta: float) -> void:
	#return
	#if shake_strength > 0.0:
		## Random small offset and rotation
		#var offset = Vector3(
			#randf_range(-1, 1),
			#randf_range(-1, 1),
			#randf_range(-1, 1)
		#) * shake_strength * max_offset
#
		#var rotation_offset = Vector3(
			#deg_to_rad(randf_range(-1, 1) * shake_strength * max_rotation),
			#deg_to_rad(randf_range(-1, 1) * shake_strength * max_rotation),
			#0.0
		#)
#
		## Apply shake
		#global_transform = original_transform
		#global_translate(offset)
		#rotate_object_local(Vector3.RIGHT, rotation_offset.x)
		#rotate_object_local(Vector3.UP, rotation_offset.y)
#
		## Decay the shake strength over time
		#shake_strength = max(shake_strength - shake_decay * delta, 0.0)
	#else:
		## Return to base position when done shaking
		#global_transform = original_transform
#
#func shake(amount: float = 1.0) -> void:
	## Add to shake intensity, capped at 1.0
	#shake_strength = clamp(shake_strength + amount, 0.0, 1.0)
