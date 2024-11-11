extends Node2D

@onready var timer: Timer = $Timer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if !GameManager.isPlayerPhase:
		#TODO add funcion que realice la accion
		GameManager.isPlayerPhase = true
		print(GameManager.isPlayerPhase)

#TODO funcion que realice la accion del boss y al finalizar se ponga "GameManager.isPlayerPhase" en true
