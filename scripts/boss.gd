extends Node2D

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

@export var maxHealthBoss = 200
@export var damage = 20
@export var habilityBoss: String
@export var nameBoss: String = "buey"

var habilityScript

func _ready() -> void:
	GameManager.BossTakeDamage.connect(UpdateProgressBar)
	GameManager.healthBoss = maxHealthBoss
	progress_bar.max_value = GameManager.healthBoss
	progress_bar.value = GameManager.healthBoss
	
	if nameBoss=="cobra":
		habilityScript = preload("res://scripts/cobraHability.gd")
	
	if nameBoss=="buey":
		habilityScript = preload("res://scripts/bueyHability.gd")
	
	if nameBoss=="lince":
		habilityScript = preload("res://scripts/linceHability.gd")


func _process(delta: float) -> void:
	if !GameManager.isPlayerPhase:
		doAction()
		GameManager.isPlayerPhase = true

#TODO funcion que realice la accion del boss y al finalizar se ponga "GameManager.isPlayerPhase" en true
func doAction():
	var rng = RandomNumberGenerator.new()
	var randomNum = int(rng.randf_range(1, 100.0))
	
	if GameManager.bossIsCharging:
		useHability()
	
	if(randomNum <= 60):
		attack(damage)
	elif (randomNum <= 85 && randomNum > 60):
		#shield()
		print("def")
	else:
		useHability()

func attack(damage):
	GameManager.healthPlayer -= damage
	GameManager.PlayerTakeDamage.emit()
	

func shield():
	print("usar escudo")

func useHability():
	var newHabilityScript = habilityScript.new()
	newHabilityScript.specialAttack()

func UpdateProgressBar():
	progress_bar.value = GameManager.healthBoss
	
	if progress_bar.value <= 0:
		#TODO hacer que el boss se muera
		print("ganaste")
