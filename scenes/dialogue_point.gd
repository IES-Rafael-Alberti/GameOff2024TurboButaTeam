extends Node2D

func _ready():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/TestTL.dtl")
