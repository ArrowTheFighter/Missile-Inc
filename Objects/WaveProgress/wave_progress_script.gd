extends ProgressBar

var spawner : EnemySpawnerScript
var wave_full_duration
var start_time
var updating_bar := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner = get_parent().enemy_spawner
	await get_tree().create_timer(spawner.Wave_Data.initial_delay).timeout
	var _duration := 0.0
	for i in spawner.Wave_Data.Wave_Section:
		_duration += i.SpawnDelay * i.SpawnCount
	
	wave_full_duration = int(_duration * 1000)
	start_time = Time.get_ticks_msec()
	updating_bar = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !updating_bar: return
	var elapsed = Time.get_ticks_msec() - start_time
	var progress = float(elapsed) / float(wave_full_duration)
	value = progress
	#print(Time.get_ticks_msec() - start_time)
	pass
