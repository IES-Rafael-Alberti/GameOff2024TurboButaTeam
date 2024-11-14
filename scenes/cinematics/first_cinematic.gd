extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("res://dialogue/timelines/FirstCinematic.dtl")
	await Dialogic.timeline_ended
	#Dialogic.start()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
