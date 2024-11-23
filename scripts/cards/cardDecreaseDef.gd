extends Node

@export var ratioMulti = .2

func action():
	GameManager.damageMultiply += ratioMulti
	GameManager.emit_signal("UpdateHistorial", "DRECREASE_HISTORY", GameManager.damageMultiply)
