extends Node

func specialAttack(specialDamage):
	if !GameManager.bossIsCharging:
		GameManager.bossIsCharging = true
		GameManager.emit_signal("UpdateHistorial", "BOSS_HABILITY_CHARGE", true)
		return
	
	if GameManager.bossIsCharging:
		if GameManager.playerShield > 0:
			print("ataca escudo")
			var damageDiff = specialDamage - GameManager.playerShield
			GameManager.playerShield -= specialDamage
			GameManager.PlayerShield.emit()
			
			if damageDiff > 0:
				GameManager.healthPlayer -= damageDiff
				GameManager.PlayerTakeDamage.emit()
			
		else:
			print("ataca")
			GameManager.healthPlayer -= specialDamage
			GameManager.PlayerTakeDamage.emit()
		
		GameManager.bossIsCharging = false
		GameManager.emit_signal("UpdateHistorial", "BOSS_HABILITY_DONE", true)
