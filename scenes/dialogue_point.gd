extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/TestTL.dtl")
