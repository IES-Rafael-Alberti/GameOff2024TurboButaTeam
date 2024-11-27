extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("start2")
	await animation_player.animation_finished
	Dialogic.start("res://dialogue/timelines/ThirdCinematic/third_cinematic.dtl")
	await Dialogic.timeline_ended
	animation_player.play("sudden_blackout")
	await animation_player.animation_finished
	Dialogic.start("finale_start")
	await Dialogic.timeline_ended
	animation_player.play("finale_fade_in")
	await animation_player.animation_finished
	Dialogic.start("finale_start_2")
	await Dialogic.timeline_ended
