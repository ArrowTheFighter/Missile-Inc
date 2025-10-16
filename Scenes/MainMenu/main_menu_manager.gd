extends Node


func load_level(id : int):
	get_tree().change_scene_to_packed(Scenes.Scenes[id])
	pass
	
func load_main_menu(id : int):
	get_tree().change_scene_to_packed(Scenes.MainMenuScene)
