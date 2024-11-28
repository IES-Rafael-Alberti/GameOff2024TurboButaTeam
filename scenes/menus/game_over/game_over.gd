extends Control

func _on_retry_button_pressed():
	GameManager.numCombat -= 1
	if Dialogic.VAR.ox_selected:
		Dialogic.VAR.ox_selected = false
	else:
		Dialogic.VAR.ox_selected = true
	
	if Dialogic.VAR.cobra_selected:
		Dialogic.VAR.cobra_selected = false
	else:
		Dialogic.VAR.cobra_selected = true
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
