extends EnemyScript

@onready var timer := $Timer
@export var side_speed := 3
var is_opened:bool
var direction:Vector3

func _ready() -> void:
	super._ready()
	direction = Vector3(-1, 0, 0).normalized()
	is_opened = false
	$WingsFolded.visible = !is_opened
	$WingsOpen.visible = is_opened
	timer.timeout.connect(_on_wing_timer_timeout)
	timer.start()

func _process(delta: float) -> void:
	super(delta)
	translate(direction * side_speed * delta)

func _on_wing_timer_timeout() -> void:
	is_opened = !is_opened
	$WingsFolded.visible = !is_opened
	$WingsOpen.visible = is_opened
	if is_opened:
		direction.x = -direction.x
	timer.start()
