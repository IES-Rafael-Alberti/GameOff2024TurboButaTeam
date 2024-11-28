extends Node

func action():
	GameManager.InitPlayerShield.emit()
	GameManager.PlayerShield.emit()
	GameManager.emit_signal("UpdateHistorial", "SHIELD_HISTORY", false)
