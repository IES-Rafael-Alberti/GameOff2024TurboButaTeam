extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var progressBarShield: ProgressBar = $ProgressBarShield
@onready var damage_bar: ProgressBar = $ProgressBar/DamageBar
@onready var timerDamage: Timer = $ProgressBar/Timer
@onready var animationBoss: AnimationPlayer = $Sprite2D/AnimationBoss
@onready var border: Sprite2D = $ProgressBar/Border

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
	GameManager.isBossTurn.connect(attackAnimation)
	GameManager.healthBoss = maxHealthBoss
	GameManager.TurnBoss.connect(turnBoss)
	
	progress_bar.max_value = GameManager.healthBoss
	progress_bar.value = GameManager.healthBoss
	damage_bar.max_value = GameManager.healthBoss
	damage_bar.value = GameManager.healthBoss
	
	newScriptBoss = scriptBoss.new()
	
	sprite_2d.texture = textureBoss
	
	progressBarShield.visible = false
	
	selectAction()
	

func turnBoss():
	if shieldIsActive:
		GameManager.QuitBossShield.emit()
		#Si ya está envenenado, vuelve a hacer daño y quita el veneno
	if GameManager.isPoisoned:
		useHability()
	
	doAction(action)
	
	if !GameManager.bossIsCharging:
		GameManager.SelectActionBoss.emit()

	GameManager.canFlip = true
	GameManager.isPlayerPhase = true
	GameManager.isPlayerTurn.emit()

func selectAction():
	var rng = RandomNumberGenerator.new()
	var randomNum = int(rng.randf_range(1, 100.0))
	# TODO activar shader segun actio
	if randomNum <= 60:
		resetShaders()
		action = "atacar"
		GameManager.emit_signal("UpdateHistorial", "BOSS_ATTACK", true)
		
	elif randomNum <= 85 && randomNum > 60:
		resetShaders()
		action = "escudo"
		GameManager.emit_signal("UpdateHistorial", "BOSS_SHIELD", true)
	else:
		resetShaders()
		action = "habilidad"
		GameManager.emit_signal("UpdateHistorial", "BOSS_HABILITY", true)
		sprite_2d.material.set_shader_parameter("isSpecial", true)
	
	if progressBarShield.visible:
		sprite_2d.material.set_shader_parameter("isProtecting", true)

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
			sprite_2d.material.set_shader_parameter("isProtecting", true)
			GameManager.emit_signal("UpdateHistorial", "BOSS_SHIELD_DONE", true)
		if action == "habilidad":
			useHability()
			sprite_2d.material.set_shader_parameter("isSpecial", false)

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
	sprite_2d.material.set_shader_parameter("bossTakeDmg", true)
	await get_tree().create_timer(2).timeout
	sprite_2d.material.set_shader_parameter("bossTakeDmg", false)
	if progress_bar.value <= 0:
		#TODO hacer que el boss se muera
		if !GameManager.isFinalCinematic:
			GameManager.bossNum = 1
			GameManager.resetBossScene()
			get_tree().change_scene_to_file.bind("res://scenes/cinematics/secondCinematic.tscn").call_deferred()
		else:
			get_tree().change_scene_to_file.bind("res://scenes/cinematics/third_cinematic.tscn").call_deferred()
	
	var health_percentage = GameManager.healthBoss / progress_bar.max_value * 100
	
	if health_percentage > 0:
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

func resetShaders():
	sprite_2d.material.set_shader_parameter("isSpecial", false)
	sprite_2d.material.set_shader_parameter("isProtecting", false)

func attackAnimation():
	if GameManager.pickedBoss.name == "OX":
		if action == "habilidad" && GameManager.bossIsCharging:
			animationBoss.play("attack")
	else:
		if action == "habilidad":
			animationBoss.play("attack")
	
	if action == "atacar":
		animationBoss.play("attack")
