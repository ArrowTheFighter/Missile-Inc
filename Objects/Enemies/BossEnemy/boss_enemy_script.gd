extends EnemyScript

@export var move_before_slow := 2.3
@export var enemy_to_spawn:PackedScene

var origin_pos : Vector3

func _ready() -> void:
	super()
	origin_pos = global_position

func _process(delta: float) -> void:
	super(delta)
	print(abs((global_position - origin_pos).length()))
	if abs((global_position - origin_pos).length()) >= move_before_slow:
		speed = 0.08
