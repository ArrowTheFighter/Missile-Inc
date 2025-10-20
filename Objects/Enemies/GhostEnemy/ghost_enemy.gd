extends EnemyScript

@onready var vis_timer := $VisibleTimer
@onready var invis_timer := $InvisibleTimer

func _ready() -> void:
	super._ready()
	vis_timer.timeout.connect(_on_vis_timer_timeout)
	invis_timer.timeout.connect(_on_invis_timer_timeout)
	vis_timer.start()

func _on_vis_timer_timeout() -> void:
	visible = false
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position - Vector3(0,0,2), .3)
	invis_timer.start()

func _on_invis_timer_timeout() -> void:
	visible = true
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", position + Vector3(0,0,2), .3)
	vis_timer.start()
