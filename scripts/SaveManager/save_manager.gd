extends Node

var settings_file:SettingsData
var settings_data_path = "user://settingsdata.tres"

var save_file:SaveFile
var save_file_path = "user://savefile.tres"

func load_settings():
	if settings_file.MasterVol == null:
		settings_file = SettingsData.new()
	settings_file = ResourceLoader.load(settings_data_path) as SettingsData
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db(settings_file.MasterVol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(settings_file.MusicVol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(settings_file.SFXVol))
	TranslationServer.set_locale(settings_file.Language)
	if OS.get_name() != "Web":
		DisplayServer.window_set_mode(settings_file.windowMode)
	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
func save_settings():
	ResourceSaver.save(settings_file,settings_data_path)

func load_game():
	save_file = ResourceLoader.load(save_file_path) as SaveFile

func save_game():
	ResourceSaver.save(save_file,save_file_path)
