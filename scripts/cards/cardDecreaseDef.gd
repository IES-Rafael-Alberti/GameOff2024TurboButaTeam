extends Node

@export var ratioMulti = .2

func action():
	GameManager.damageMultiply += ratioMulti
	print(GameManager.damageMultiply)
