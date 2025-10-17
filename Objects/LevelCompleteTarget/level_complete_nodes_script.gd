extends Node3D


func ShowLevelComplete():
	ToggleLevelComplete(true)
	
func HideLevelComplete():
	ToggleLevelComplete(false)

func ToggleLevelComplete(show : bool):
	if show:
		var tween = create_tween()
		var hidden_pos = Vector3(position.x,position.y,0)
		tween.tween_property(self,"position",hidden_pos,1.5)
	else:
		var tween = create_tween()
		var visible_pos = Vector3(position.x,position.y,-3)
		tween.tween_property(self,"position",visible_pos,1.5)
