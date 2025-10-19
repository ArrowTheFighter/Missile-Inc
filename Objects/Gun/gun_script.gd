extends Node3D
var Fired := false
var Power := 2.5
var Target_Pos : Vector3
var Ammo_Loaded := false
var Ammo_Shot := false
var Ammo_Chamber_Open := false
@export var Use_Crosshair := false
@export var Crosshair_Obj : Crosshair
@export var Bullet_Scene : PackedScene
@export var readyToFireMat : MeshInstance3D
@export var ammo_mesh : MeshInstance3D
@export_category("Power Settings")
@export var Default_Power := 2.5
@export var min_power := 2.5
@export var max_power := 7
@export_category("Reloading Settings")
@export var Require_Reloading := false
signal Ammo_Chamber_State_Changed(bool)

func _ready() -> void:
	Ammo_Chamber_State_Changed.emit(Ammo_Chamber_Open)
	Rotate_Gun(0)
	Power = Default_Power
	if Use_Crosshair and Crosshair_Obj != null:
		Crosshair_Obj.positionUpdated.connect(Aim_At_Target_Position)
	

func Rotate_Gun(value : float):
	rotation_degrees.z = lerp(45,-45,value)
	pass
	
func Aim_At_Target_Position(target_position : Vector3):
	Target_Pos = target_position
	var direction = (target_position - global_position).normalized()
	var angle = atan2(direction.y, direction.x) - deg_to_rad(90)  # Rotate -90 degrees
	rotation.z = angle
	
func Set_Power(value : float):
	Power = lerp(2.5,7.0,value)
	pass
	
func Fire_Gun(value : float):
	if(!Fired and value >= 0.9 ):
		if Require_Reloading:
			if !Ammo_Loaded or Ammo_Shot or Ammo_Chamber_Open: return
		Fired = true
		Ammo_Shot = true
		if readyToFireMat != null:
			var mat = readyToFireMat.get_active_material(0)
			if mat is StandardMaterial3D:
				mat = mat.duplicate()
				mat.albedo_color = Color.RED
				readyToFireMat.set_surface_override_material(0,mat)
		if ammo_mesh != null:
			var ammo_mat = ammo_mesh.get_active_material(0)
			if ammo_mat is StandardMaterial3D:
				ammo_mat = ammo_mat.duplicate()
				ammo_mat.albedo_color = Color.DARK_GRAY
				ammo_mesh.set_surface_override_material(0,ammo_mat)
		
		if Bullet_Scene != null:
			var spawnedBulletScene = Bullet_Scene.instantiate()
			spawnedBulletScene.rotation_degrees = rotation_degrees
			spawnedBulletScene.position = global_position + Vector3(0,0,-0.2)
			spawnedBulletScene.speed = Power
			spawnedBulletScene.target_pos = Target_Pos
			get_tree().root.add_child(spawnedBulletScene)
		get_tree().call_group("Camera","shake",0.2)
	elif Fired and value <= 0.1:
		Fired = false;
		var mat = readyToFireMat.get_active_material(0)
		if mat is StandardMaterial3D:
			mat = mat.duplicate()
			mat.albedo_color = Color.GREEN
			readyToFireMat.set_surface_override_material(0,mat)
	pass
	
func Load_Ammo(value : float):
	if !Ammo_Loaded and !Ammo_Shot and value > 0.9:
		if Ammo_Chamber_Open:
			Ammo_Loaded = true
			if ammo_mesh != null:
				var ammo_mat = ammo_mesh.get_active_material(0)
				if ammo_mat is StandardMaterial3D:
					ammo_mat = ammo_mat.duplicate()
					ammo_mat.albedo_color = Color.DARK_GREEN
					ammo_mesh.set_surface_override_material(0,ammo_mat)
	elif Ammo_Loaded and value < 0.1:
		Ammo_Loaded = false
	pass
	
func Open_Ammo_Chamber(value : float):
	if !Ammo_Chamber_Open and value > 0.9:
		Ammo_Chamber_Open = true
		Ammo_Chamber_State_Changed.emit(true)
	elif Ammo_Chamber_Open and value < 0.1:
		Ammo_Chamber_Open = false
		Ammo_Chamber_State_Changed.emit(false)

func Remove_Empty_Ammo(value : float):
	if !Ammo_Loaded and Ammo_Shot:
		Ammo_Shot = false
		if ammo_mesh != null:
			var ammo_mat = ammo_mesh.get_active_material(0)
			if ammo_mat is StandardMaterial3D:
				ammo_mat = ammo_mat.duplicate()
				ammo_mat.albedo_color = Color.DARK_RED
				ammo_mesh.set_surface_override_material(0,ammo_mat)
