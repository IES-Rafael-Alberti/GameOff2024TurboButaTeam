extends Node

func specialAttack(specialDamage):
	GameManager.healthPlayer -= specialDamage
	GameManager.PlayerTakeDamage.emit()
	GameManager.emit_signal("UpdateHistorial", "BOSS_HABILITY_DONE", true)
	
	if GameManager.isPoisoned:
		GameManager.isPoisoned = false
	else:
		GameManager.isPoisoned = true
