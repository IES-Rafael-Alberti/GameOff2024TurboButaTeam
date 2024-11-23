extends Node

func action():
	GameManager.FlipTwoCard.emit()
	GameManager.emit_signal("UpdateHistorial", "FLIP_HISTORY", null)
