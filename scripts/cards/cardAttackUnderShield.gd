extends Node

@export var damage = 50

func action():
	GameManager.healthBoss -= damage * GameManager.damageMultiply
	GameManager.BossTakeDamage.emit()
	GameManager.BossShield.emit()
	
