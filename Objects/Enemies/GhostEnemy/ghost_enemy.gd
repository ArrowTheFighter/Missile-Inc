extends EnemyScript

@onready var vis_timer := $VisibleTimer
@onready var invis_timer := $InvisibleTimer
var is_visible:bool

func _ready() -> void:
	super._ready()
	is_visible = true
	vis_timer.timeout.connect(_on_vis_timer_timeout)
	invis_timer.timeout.connect(_on_invis_timer_timeout)
	vis_timer.start()

func _on_vis_timer_timeout() -> void:
	is_visible = false
	print("going invis")
	visible = is_visible
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position - Vector3(0,0,2), .3)
	invis_timer.start()
	
func _on_invis_timer_timeout() -> void:
	is_visible = true
	print("going vis")
	visible = is_visible
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position + Vector3(0,0,2), .3)
	vis_timer.start()
