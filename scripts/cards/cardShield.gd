extends Node

func action():
	GameManager.InitPlayerShield.emit()
	GameManager.emit_signal("UpdateHistorial", "SHIELD_HISTORY", null)
