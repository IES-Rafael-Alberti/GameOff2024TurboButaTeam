extends Node2D

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("start2")
	await animation_player.animation_finished
	Dialogic.start("res://dialogue/timelines/ThirdCinematic/third_cinematic.dtl")
