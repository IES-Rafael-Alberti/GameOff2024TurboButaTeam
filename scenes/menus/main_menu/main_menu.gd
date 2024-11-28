extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var play_button: Button = $VBoxContainer/VBoxContainer/PlayButton
@onready var options_button: Button = $VBoxContainer/VBoxContainer/OptionsButton
@onready var wiki_button: Button = $VBoxContainer/VBoxContainer/WikiButton
@onready var exit_button: Button = $VBoxContainer/VBoxContainer/ExitButton
@onready var credits_button = $creditsButton

func _ready():
	v_box_container.set_modulate(Color(0,0,0,0))
	animation_player.play("fade_in")
	if OS.get_name()=="Web":
		exit_button.hide()

func _on_play_button_pressed():
	play_button.disabled = true
	options_button.disabled = true
	wiki_button.disabled = true
	exit_button.disabled = true
	credits_button.disabled = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/cinematics/first_cinematic.tscn")

func _on_options_button_pressed():
	play_button.disabled = true
	options_button.disabled = true
	wiki_button.disabled = true
	exit_button.disabled = true
	credits_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/options_menu/options_menu.tscn")

func _on_exit_button_pressed() -> void:
	play_button.disabled = true
	options_button.disabled = true
	wiki_button.disabled = true
	exit_button.disabled = true
	credits_button.disabled = true
	get_tree().quit()

func _on_wiki_button_pressed() -> void:
	play_button.disabled = true
	options_button.disabled = true
	wiki_button.disabled = true
	exit_button.disabled = true
	credits_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/menus/wiki_screen/wiki_screen.tscn")


func _on_credits_button_pressed():
	play_button.disabled = true
	options_button.disabled = true
	wiki_button.disabled = true
	exit_button.disabled = true
	credits_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/menus/credits/credits.tscn")
