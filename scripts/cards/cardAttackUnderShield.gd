extends Node

@export var damage = 100

func action():
	GameManager.healthBoss -= damage * GameManager.damageMultiply
	GameManager.BossTakeDamage.emit()
	GameManager.BossShield.emit()
	GameManager.emit_signal("UpdateHistorial", "ATTACK_UNDER_HISTORY", damage)
