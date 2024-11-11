extends Node2D

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

@export var maxHealthBoss = 200

func _ready() -> void:
	GameManager.BossTakeDamage.connect(UpdateProgressBar)
	GameManager.healthBoss = maxHealthBoss
	progress_bar.max_value = GameManager.healthBoss
	progress_bar.value = GameManager.healthBoss

func _process(delta: float) -> void:
	if !GameManager.isPlayerPhase:
		#TODO add funcion que realice la accion
		UseHability()
		GameManager.isPlayerPhase = true

#TODO funcion que realice la accion del boss y al finalizar se ponga "GameManager.isPlayerPhase" en true
func UseHability():
	print("hace habilidad")

func UpdateProgressBar():
	progress_bar.value = GameManager.healthBoss
	
	if progress_bar.value <= 0:
		#TODO hacer que el boss se muera
		print("ganaste")
