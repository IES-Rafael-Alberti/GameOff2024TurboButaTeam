extends Node

func specialAttack(specialDamage):
	if !GameManager.bossIsCharging:
		GameManager.bossIsCharging = true
		return
	
	if GameManager.bossIsCharging:
		GameManager.healthPlayer -= specialDamage
		GameManager.PlayerTakeDamage.emit()
		GameManager.bossIsCharging = false
