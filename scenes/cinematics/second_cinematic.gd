extends Node2D

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("start")
	await animation_player.animation_finished
	Dialogic.start("res://dialogue/timelines/SecondCinematic/second_cinematic.dtl")
	await Dialogic.timeline_ended
	animation_player.play("end")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
