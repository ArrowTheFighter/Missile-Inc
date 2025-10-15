extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func set_cover_position(value : float):
	var height = self.mesh.size.y
	position.y = lerp(0.0,height,value)
	pass
