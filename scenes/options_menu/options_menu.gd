extends Control

@onready var master_vol = $VBoxContainer/VBoxContainer3/VBoxContainer/HBoxContainer/MasterVol
@onready var music_vol = $VBoxContainer/VBoxContainer3/VBoxContainer/HBoxContainer2/MusicVol
@onready var sfx_vol = $VBoxContainer/VBoxContainer3/VBoxContainer/HBoxContainer3/SFXVol
@onready var window_mode_hbox = $VBoxContainer/VBoxContainer3/VBoxContainer2/WindowModeHbox
@onready var window_mode = $VBoxContainer/VBoxContainer3/VBoxContainer2/WindowModeHbox/WindowMode
@onready var test_sfx = $VBoxContainer/VBoxContainer3/VBoxContainer/HBoxContainer3/testSFX
@onready var language_sel = $VBoxContainer/VBoxContainer3/VBoxContainer2/LanguageHbox/LanguageSel

var master_bus
var music_bus
var sfx_bus
func _ready() -> void:
	if OS.get_name()=="Web":
		window_mode_hbox.hide()
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	master_vol.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_vol.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfx_vol.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")

func _on_master_vol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus,linear_to_db(value))

func _on_music_vol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus,linear_to_db(value))

func _on_sfx_vol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus,linear_to_db(value))
func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_language_sel_item_selected(index):
	match index:
		0:
			TranslationServer.set_locale("en") #TODO bug viewport aquí
		1:
			TranslationServer.set_locale("es")


func _on_sfx_vol_drag_ended(value_changed):
	test_sfx.play()
