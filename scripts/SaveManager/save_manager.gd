extends Node

var settings_file:SettingsData
var settings_data_path = "user://settingsdata.tres"

var save_file:SaveFile
var save_file_path = "user://savefile.tres"

func load_settings():
	settings_file = ResourceLoader.load(settings_data_path) as SettingsData

func save_settings():
	ResourceSaver.save(settings_file,settings_data_path)

func load_game():
	save_file = ResourceLoader.load(save_file_path) as SaveFile

func save_game():
	ResourceSaver.save(save_file,save_file_path)
