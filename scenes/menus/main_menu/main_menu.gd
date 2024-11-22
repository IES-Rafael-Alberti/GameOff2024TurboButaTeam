extends Control

#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var exit_button: Button = $VBoxContainer/VBoxContainer/Button3

func _ready():
	#v_box_container.set_modulate(Color(0,0,0,0))
	#animation_player.play("fade_in")
	print(OS.get_name())
	if OS.get_name()=="Web":
		exit_button.hide()

func _on_play_button_pressed():
	#animation_player.play("fade_out")
	#await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/cinematics/first_cinematic.tscn")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options_menu/options_menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
