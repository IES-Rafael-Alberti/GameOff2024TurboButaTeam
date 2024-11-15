extends Node2D

func _ready():
	await get_tree().create_timer(5)
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1Start.dtl")
