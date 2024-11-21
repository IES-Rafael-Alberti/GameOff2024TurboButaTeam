extends Node

func specialAttack(specialDamage):
	var rng = RandomNumberGenerator.new()
	var attackCount = int(rng.randf_range(2, 5))
	var damageDiff = 0
	for i in attackCount:
		if GameManager.playerShield > 0:
			damageDiff = specialDamage - GameManager.playerShield
			GameManager.playerShield -= specialDamage
			GameManager.PlayerShield.emit()
		
		if damageDiff > 0:
			GameManager.healthPlayer -= damageDiff
			GameManager.PlayerTakeDamage.emit()
		else:
			GameManager.healthPlayer -= specialDamage
			GameManager.PlayerTakeDamage.emit()
