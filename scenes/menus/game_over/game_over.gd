extends Control

func _ready():
	pass # Replace with function body.


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
