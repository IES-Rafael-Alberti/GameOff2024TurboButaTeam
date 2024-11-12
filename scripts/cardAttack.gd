extends Node

@export var damage = 200

func action():
	print("Carta de ataque")
	GameManager.healthBoss -= damage
	GameManager.BossTakeDamage.emit()
