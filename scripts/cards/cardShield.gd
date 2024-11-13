extends Node

@export var shieldMaxValue = 50
@onready var progress_bar_shield = %ProgressBarShield


func action():
	GameManager.playerShield = shieldMaxValue
