extends Bullet_Base

@export var Explosion_Area : Area3D
var tracked_areas : Array[Area3D]
var death_sound_stream = preload("uid://bthc58y84k1st")
var death_sound

func _ready() -> void:
	super()
	Explosion_Area.area_entered.connect(Explosion_Area_Entered)
	Explosion_Area.area_exited.connect(Explosion_Area_Exited)
	HitEnemy.connect(explode)
	
	_prepare_death_sound()

func _move_bullet(delta):
	global_translate(transform.basis.y * speed * delta)
	
func _process(delta: float) -> void:
	super(delta)
	var current_pos = global_position
	current_pos.z = target_pos.z
	if((current_pos - target_pos).length() < 0.05):
		explode()
		
func _prepare_death_sound()->void:
	if not death_sound_stream: return
	death_sound = AudioStreamPlayer.new()
	death_sound.stream = death_sound_stream
	death_sound.name = "DeathSound"
	death_sound.volume_db = -15
	get_tree().root.call_deferred("add_child", death_sound)
		
func explode():
	for area in tracked_areas:
		if area.get_parent() != null:
			if area.get_parent().has_method("take_damage"):
				area.get_parent().call("take_damage",1)
	if death_particle != null:
		var instanced_death_particle = death_particle.instantiate()
		get_tree().root.add_child(instanced_death_particle)
		instanced_death_particle.global_position = global_position
	if death_sound:
		death_sound.play()
		death_sound.finished.connect(func():death_sound.queue_free())
	queue_free()
		
func Explosion_Area_Entered(area : Area3D):
	tracked_areas.append(area)
	pass
	
func Explosion_Area_Exited(area : Area3D):
	tracked_areas.erase(area)
	pass
