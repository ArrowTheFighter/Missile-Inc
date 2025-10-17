extends CanvasLayer

@export var end_match_buttons : Array[Control]
@export var enemy_spawner : EnemySpawnerScript

func _ready() -> void:
	#enemy_spawner.match_ended.connect(show_match_end_buttons)
	pass
# Called when the node enters the scene tree for the first time.
func show_match_end_buttons():
	for i in end_match_buttons:
		i.visible = true
	
