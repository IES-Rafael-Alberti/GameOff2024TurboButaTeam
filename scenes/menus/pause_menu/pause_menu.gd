extends Control

func _on_resume_button_pressed():
	self.visible = false

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
