extends Control

func _on_resume_button_pressed():
	self.visible = false

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")


func _on_resume_button_2_pressed() -> void:
	var options = preload("res://scenes/options_menu/options_menu_pause.tscn")
	get_tree().root.add_child(options.instantiate())
