extends Node

@export var damage = 100

func action():
	if GameManager.bossShield > 0:
		var damageDiff = damage - GameManager.bossShield
		GameManager.bossShield -= damage
		GameManager.BossShield.emit()
		
		if damageDiff > 0:
			GameManager.healthPlayer -= damageDiff
			GameManager.PlayerTakeDamage.emit()
		
	else:
		GameManager.healthBoss -= damage
		GameManager.BossTakeDamage.emit()
		GameManager.emit_signal("UpdateHistorial", "ATTACK_HISTORY", false)
