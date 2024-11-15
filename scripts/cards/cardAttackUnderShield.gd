extends Node

@export var damage = 20

func action():
	GameManager.healthBoss -= damage * GameManager.damageMultiply
	GameManager.BossTakeDamage.emit()
	GameManager.BossShield.emit()
