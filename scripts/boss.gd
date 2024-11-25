extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var progressBarShield: ProgressBar = $ProgressBarShield
@onready var damage_bar: ProgressBar = $ProgressBar/DamageBar
@onready var timerDamage: Timer = $ProgressBar/Timer

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
var hasEmited80 = false 
var hasEmited60 = false 
var hasEmited40 = false 
var hasEmited20 = false 
var hasEmited10 = false 

func _ready() -> void:
	GameManager.BossTakeDamage.connect(UpdateProgressBar)
	GameManager.BossShield.connect(updateShield)
	GameManager.InitBossShield.connect(initShield)
	GameManager.QuitBossShield.connect(removeShield)
	GameManager.SelectActionBoss.connect(selectAction)
	GameManager.healthBoss = maxHealthBoss
	
	progress_bar.max_value = GameManager.healthBoss
	progress_bar.value = GameManager.healthBoss
	damage_bar.max_value = GameManager.healthBoss
	damage_bar.value = GameManager.healthBoss
	
	newScriptBoss = scriptBoss.new()
	
	
	sprite_2d.texture = textureBoss
	
	progressBarShield.visible = false
	
	selectAction()

func _process(delta: float) -> void:
	if !GameManager.isPlayerPhase:
		if shieldIsActive:
			GameManager.QuitBossShield.emit()
		#Si ya está envenenado, vuelve a hacer daño y quita el veneno
		if GameManager.isPoisoned:
			useHability()
		
		doAction(action)
		GameManager.isPlayerPhase = true
		
		if !GameManager.bossIsCharging:
			GameManager.SelectActionBoss.emit()
		else:
			GameManager.emit_signal("UpdateHistorial", "BOSS_HABILITY_CHARGE", true)

func selectAction():
	var rng = RandomNumberGenerator.new()
	var randomNum = int(rng.randf_range(1, 100.0))
	if randomNum <= 60:
		action = "atacar"
		GameManager.emit_signal("UpdateHistorial", "BOSS_ATTACK", true)
		
	elif randomNum <= 85 && randomNum > 60:
		action = "escudo"
		GameManager.emit_signal("UpdateHistorial", "BOSS_SHIELD", true)
	else:
		action = "habilidad"
		GameManager.emit_signal("UpdateHistorial", "BOSS_HABILITY", true)
		

#TODO funcion que realice la accion del boss y al finalizar se ponga "GameManager.isPlayerPhase" en true
func doAction(action):
	if GameManager.bossIsCharging:
		useHability()
	else:
		if action == "atacar":
			attack(damageBoss)
			GameManager.emit_signal("UpdateHistorial", "BOSS_ATTACK_DONE", true)
		if action == "escudo":
			shield()
			GameManager.emit_signal("UpdateHistorial", "BOSS_SHIELD_DONE", true)
		if action == "habilidad":
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
		GameManager.bossNum = 1
		get_tree().change_scene_to_file.bind("res://scenes/game.tscn").call_deferred()
	
	var health_percentage = GameManager.healthBoss / progress_bar.max_value * 100
	
	if health_percentage <= 10 and !hasEmited10:
		hasEmited10 = true
		GameManager.TenOfLife.emit()
	elif health_percentage <= 20 and !hasEmited20:
		hasEmited20 = true
		GameManager.TwentyOfLife.emit()
	elif health_percentage <= 40 and !hasEmited40:
		hasEmited40 = true
		GameManager.FortyOfLife.emit()
	elif health_percentage <= 60 and !hasEmited60:
		hasEmited60 = true
		GameManager.SixtyOfLife.emit()
	elif health_percentage <= 80 and !hasEmited80:
		hasEmited80 = true
		GameManager.EightyOfLife.emit()

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
