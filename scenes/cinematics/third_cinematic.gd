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
	animation_player.play("final_text_transition")
	await animation_player.animation_finished
	animation_player.play("zoom1")
	Dialogic.start("big_finale_1")
	await Dialogic.timeline_ended
	animation_player.play("zoom2")
	Dialogic.start("big_finale_2")
	await Dialogic.timeline_ended
	animation_player.play("zoom3")
	Dialogic.start("big_finale_3")
	await Dialogic.timeline_ended
	animation_player.play("sudden_blackout_final")
