extends Control

func _on_eng_pressed() -> void:
	TranslationServer.set_locale("en")
	get_tree().change_scene_to_file("res://scenes/cinematics/first_cinematic.tscn")

func _on_esp_pressed() -> void:
	TranslationServer.set_locale("es")
	get_tree().change_scene_to_file("res://scenes/cinematics/first_cinematic.tscn")
