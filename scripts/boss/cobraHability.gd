extends Node

func specialAttack(specialDamage):
	GameManager.healthPlayer -= specialDamage
	GameManager.PlayerTakeDamage.emit()
	
	if GameManager.isPoisoned:
		GameManager.isPoisoned = false
	else:
		GameManager.isPoisoned = true
