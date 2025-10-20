extends Bullet_Base

@export var Explosion_Area : Area3D
var tracked_areas : Array[Area3D]

func _ready() -> void:
	super()
	Explosion_Area.area_entered.connect(Explosion_Area_Entered)
	Explosion_Area.area_exited.connect(Explosion_Area_Exited)
	HitEnemy.connect(explode)

func _move_bullet(delta):
	global_translate(transform.basis.y * speed * delta)
	
func _process(delta: float) -> void:
	super(delta)
	var current_pos = global_position
	current_pos.z = target_pos.z
	if((current_pos - target_pos).length() < 0.05):
		explode()
		
func explode():
	for area in tracked_areas:
		if area.get_parent() != null:
			if area.get_parent().has_method("take_damage"):
				area.get_parent().call("take_damage",1)
	if death_particle != null:
		var instanced_death_particle = death_particle.instantiate()
		get_tree().root.add_child(instanced_death_particle)
		instanced_death_particle.global_position = global_position
	queue_free()
		
func Explosion_Area_Entered(area : Area3D):
	tracked_areas.append(area)
	pass
	
func Explosion_Area_Exited(area : Area3D):
	tracked_areas.erase(area)
	pass
