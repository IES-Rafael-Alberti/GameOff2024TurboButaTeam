extends Node

func action():
	GameManager.doubleShift = true
	GameManager.emit_signal("UpdateHistorial", "DOUBLE_SHIFT_HISTORY", null)
