extends Node2D


@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var progressBarShield: ProgressBar = $ProgressBarShield
@onready var damage_bar: ProgressBar = $ProgressBar/DamageBar
@onready var timerDamage: Timer = $ProgressBar/Timer
@onready var battleLog: Label = $ColorRect/BattleLog
@onready var timerTurn: Timer = $TimerTurn

@export var maxHealthBoss = 200
@export var damageBoss = 20
@export var specialDamage = 10
@export var scriptBoss: Script
@export var textureBoss = Texture

var habilityScript
var shieldMaxValue = 50
var action
var newScriptBoss
var shieldIsActive = false

func _ready() -> void:
	GameManager.BossTakeDamage.connect(UpdateProgressBar)
	GameManager.BossShield.connect(updateShield)
	GameManager.InitBossShield.connect(initShield)
	GameManager.QuitBossShield.connect(removeShield)
	GameManager.SelectActionBoss.connect(selectAction)
	GameManager.TurnBoss.connect(turnBoss)
	GameManager.healthBoss = maxHealthBoss
	
	progress_bar.max_value = GameManager.healthBoss
	progress_bar.value = GameManager.healthBoss
	damage_bar.max_value = GameManager.healthBoss
	damage_bar.value = GameManager.healthBoss
	
	newScriptBoss = scriptBoss.new()
	
	
	sprite_2d.texture = textureBoss
	
	progressBarShield.visible = false
	
	battleLog.text = ""
	
	selectAction()

func turnBoss():
	if shieldIsActive:
		GameManager.QuitBossShield.emit()
	#var timer = Timer.new()
	#timer.wait_time = 1
	#timer.one_shot = true
	#add_child(timer)
	#timer.start()
	#await timer.timeout
	#timer.queue_free()
	
	if GameManager.isPoisoned:
		useHability()
	
	doAction(action)
	GameManager.changeVisibleCadenas.emit()
	if !GameManager.bossIsCharging:
		GameManager.SelectActionBoss.emit()
	else:
		battleLog.text = "BOSS_HABILITY_CHARGE"
	GameManager.isPlayerPhase = true

func selectAction():
	var rng = RandomNumberGenerator.new()
	var randomNum = int(rng.randf_range(1, 100.0))
	
	if randomNum <= 60:
		action = "atacar"
		battleLog.text = "BOSS_ATTACK"
		
	elif randomNum <= 85 && randomNum > 60:
		action = "escudo"
		battleLog.text = "BOSS_SHIELD"
	else:
		action = "habilidad"
		battleLog.text = "BOSS_HABILITY"

func doAction(action):
	if GameManager.bossIsCharging:
		useHability()
	else:
		if action == "atacar":
			print("atacar")
			attack(damageBoss)
		if action == "escudo":
			print("escudo")
			shield()
		if action == "habilidad":
			print("habilidad")
			useHability()

func attack(damageBoss):
	if GameManager.playerShield > 0:
		var damageDiff = damageBoss - GameManager.playerShield
		GameManager.playerShield -= damageBoss
		GameManager.PlayerShield.emit()
		
		if damageDiff > 0:
			GameManager.healthPlayer -= damageDiff
			GameManager.PlayerTakeDamage.emit()
		
	else:
		GameManager.healthPlayer -= damageBoss
		GameManager.PlayerTakeDamage.emit()

func shield():
	GameManager.InitBossShield.emit()
	shieldIsActive = true

func useHability():
	newScriptBoss.specialAttack(specialDamage)

func UpdateProgressBar():
	timerDamage.start()
	progress_bar.value = GameManager.healthBoss
	if progress_bar.value <= 0:
		#TODO hacer que el boss se muera
		print("ganaste")

func updateShield():
	progressBarShield.max_value = shieldMaxValue
	progressBarShield.value = GameManager.bossShield

func initShield():
	GameManager.bossShield = shieldMaxValue
	progressBarShield.value = shieldMaxValue
	progressBarShield.visible = true

func removeShield():
	progressBarShield.visible = false
	GameManager.bossShield = 0


func _on_timer_timeout() -> void:
	damage_bar.value = GameManager.healthBoss
