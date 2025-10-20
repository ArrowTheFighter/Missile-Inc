extends EnemyScript

@export var move_before_slow := 2.3
@export var enemy_to_spawn:PackedScene
@export var stop_after_distance := 0.0
@export var invincible := true
@export var enemies_to_spawn : Array[PackedScene]
var distance_moved := 0.0

var origin_pos : Vector3

func _ready() -> void:
	super()
	origin_pos = global_position

func _process(delta: float) -> void:
	if(abs(global_position - origin_pos).length() <= stop_after_distance):
		translate(Vector3.DOWN * speed * delta)
		distance_moved += speed * delta
		

		
func take_damage(amount : int):
	if !invincible:
		super(amount)
		toggle_invincible()
		$Timer.stop()
		$Timer.start()

func toggle_invincible():
	invincible = !invincible
	$visuals/mouth/Shield.visible = invincible
	if (invincible == false):
		spawn_enemy()
		
func spawn_enemy():
	var enemy_scene = enemies_to_spawn.pick_random()
	var enemy_instance = enemy_scene.instantiate()
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = $Marker3D.global_position
	
