extends Node3D
var Fired := false
@export var Bullet_Scene : PackedScene
@export var readyToFireMat : MeshInstance3D

func Rotate_Gun(value : float):
	rotation_degrees.z = lerp(45,-45,value)
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
