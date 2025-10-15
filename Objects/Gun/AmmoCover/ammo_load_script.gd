extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func set_cover_position(value : float):
	var length = self.mesh.size.x
	position.x = lerp(0.0,length,value)
	pass
