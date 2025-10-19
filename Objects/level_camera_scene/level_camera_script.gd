extends Camera3D

@export var shake_decay := 5.0         # How quickly shake fades out
@export var max_offset := 0.2          # Max positional offset (in meters)
@export var max_rotation := 2.0        # Max rotation offset (in degrees)

var shake_strength := 0.0              # Current shake intensity
@onready var original_transform: Transform3D   # Store camera's base transform

func _ready() -> void:
	# Save original transform so we can return to it cleanly
	original_transform = global_transform

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		# Random small offset and rotation
		print("shaking")
		var offset = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * shake_strength * max_offset

		var rotation_offset = Vector3(
			deg_to_rad(randf_range(-1, 1) * shake_strength * max_rotation),
			deg_to_rad(randf_range(-1, 1) * shake_strength * max_rotation),
			0.0
		)

		# Apply shake
		global_transform = original_transform
		global_translate(offset)
		rotate_object_local(Vector3.RIGHT, rotation_offset.x)
		rotate_object_local(Vector3.UP, rotation_offset.y)

		# Decay the shake strength over time
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
	else:
		# Return to base position when done shaking
		global_transform = original_transform

func shake(amount: float = 1.0) -> void:
	# Add to shake intensity, capped at 1.0
	shake_strength = clamp(shake_strength + amount, 0.0, 1.0)
