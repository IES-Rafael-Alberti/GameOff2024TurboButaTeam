extends Node

@export var damage = 20

func action():
	print("Carta de ataque")
	GameManager.healthBoss -= damage * GameManager.damageMultiply
	GameManager.BossTakeDamage.emit()
