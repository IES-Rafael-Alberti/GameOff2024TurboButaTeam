extends Control

@onready var master_vol: HSlider = $VBoxContainer/GridContainer/MasterVol
@onready var music_vol: HSlider = $VBoxContainer/GridContainer/MusicVol
@onready var sfx_vol: HSlider = $VBoxContainer/GridContainer/SFXVol
@onready var window_mode: OptionButton = $VBoxContainer/GridContainer/WindowMode
@onready var language_sel: OptionButton = $VBoxContainer/GridContainer/LanguageSel
@onready var back_button: Button = $MarginContainer/BackButton
@onready var label_4: Label = $VBoxContainer/GridContainer/Label4
@onready var test_sfx: AudioStreamPlayer2D = $VBoxContainer/testSFX

var master_bus
var music_bus
var sfx_bus
func _ready() -> void:
	var locale = TranslationServer.get_locale()
	if locale == "en":
		language_sel.select(0)
	elif locale == "es":
		language_sel.select(1)
	if OS.get_name()=="Web":
		label_4.hide()
		window_mode.hide()
	else:
		window_mode.select(DisplayServer.window_get_mode()-1)
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	master_vol.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_vol.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfx_vol.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
func _on_back_button_pressed() -> void:
	visible = false
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
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("es")


func _on_sfx_vol_drag_ended(value_changed):
	test_sfx.play()
