extends Node3D
var Fired := false
var Power := 2.5
@export var Use_Crosshair := false
@export var Crosshair : Crosshair
@export var Bullet_Scene : PackedScene
@export var readyToFireMat : MeshInstance3D

func _ready() -> void:
	Rotate_Gun(0)
	if Use_Crosshair and Crosshair != null:
		Crosshair.positionUpdated.connect(Aim_At_Target_Position)
	

func Rotate_Gun(value : float):
	rotation_degrees.z = lerp(45,-45,value)
	pass
	
func Aim_At_Target_Position(target_position : Vector3):
	var direction = (target_position - global_position).normalized()
	var angle = atan2(direction.y, direction.x) - deg_to_rad(90)  # Rotate -90 degrees
	rotation.z = angle
	
func Set_Power(value : float):
	Power = lerp(2.5,7.0,value)
	pass
	
func Fire_Gun(value : float):
	if(!Fired and value >= 0.9):
		Fired = true
		var mat = readyToFireMat.get_active_material(0)
		if mat is StandardMaterial3D:
			mat = mat.duplicate()
			mat.albedo_color = Color.RED
			readyToFireMat.set_surface_override_material(0,mat)
		
		if Bullet_Scene != null:
			var spawnedBulletScene = Bullet_Scene.instantiate()
			spawnedBulletScene.rotation_degrees = rotation_degrees
			spawnedBulletScene.position = global_position
			spawnedBulletScene.speed = Power
			get_tree().root.add_child(spawnedBulletScene)
		print("firing")
	elif Fired and value <= 0.1:
		Fired = false;
		var mat = readyToFireMat.get_active_material(0)
		if mat is StandardMaterial3D:
			mat = mat.duplicate()
			mat.albedo_color = Color.GREEN
			readyToFireMat.set_surface_override_material(0,mat)
		print("ready to fire")
	pass
