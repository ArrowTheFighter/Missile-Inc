extends MeshInstance3D


func HideBackground():
	SetHidden(false)
	
func ShowBackground():
	SetHidden(true)

func SetHidden(hidden : bool):
	if hidden:
		var tween = create_tween()
		var hidden_pos = Vector3(position.x,position.y,1)
		tween.tween_property(self,"position",hidden_pos,1.5)
	else:
		var tween = create_tween()
		var visible_pos = Vector3(position.x,position.y,0)
		tween.tween_property(self,"position",visible_pos,1.5)
