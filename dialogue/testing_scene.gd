extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.start("res://dialogue/timelines/TestTL.dtl")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
