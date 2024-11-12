extends Node

@export var specialDamage = 200

func specialAttack():
	if !GameManager.bossIsCharging:
		GameManager.bossIsCharging = true
		return
	
	if GameManager.bossIsCharging:
		GameManager.healthPlayer -= specialDamage
		GameManager.PlayerTakeDamage.emit()
		GameManager.bossIsCharging = false
	
