extends Marker2D

func _ready():
	await get_tree().create_timer(2)
	var layout = Dialogic.Styles.load_style("textbubble")
	layout.register_character(load("res://dialogue/characters/testboss.dch"), $".")
	Dialogic.start("res://dialogue/timelines/BF1_OX/OxStart.dtl")
