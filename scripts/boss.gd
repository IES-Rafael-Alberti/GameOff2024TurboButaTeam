extends Node2D


@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $ProgressBar/Label
@onready var labelShield: Label = $ProgressBarShield/Label
@onready var progressBarShield: ProgressBar = $ProgressBarShield
@onready var battleLog: Label = $BattleLog

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
	GameManager.healthBoss = maxHealthBoss
	progress_bar.max_value = GameManager.healthBoss
	progress_bar.value = GameManager.healthBoss
	
	newScriptBoss = scriptBoss.new()
	
	label.text = str(GameManager.healthBoss) + " / " + str(GameManager.healthBoss)
	
	sprite_2d.texture = textureBoss
	
	progressBarShield.visible = false
	
	battleLog.text = ""
	
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
		GameManager.SelectActionBoss.emit()

func selectAction():
	var rng = RandomNumberGenerator.new()
	var randomNum = int(rng.randf_range(1, 100.0))
	
	if randomNum <= 60:
		action = "atacar"
		battleLog.text = "el boss va a usar atacar"
		
	elif randomNum <= 85 && randomNum > 60:
		action = "escudo"
		battleLog.text = "el boss va a usar escudo"
	else:
		action = "habilidad"
		battleLog.text = "el boss va a usar habilidad"

#TODO funcion que realice la accion del boss y al finalizar se ponga "GameManager.isPlayerPhase" en true
func doAction(action):
	
	if GameManager.bossIsCharging:
		useHability()
	
	if action == "atacar":
		attack(damageBoss)
	if action == "escudo":
		shield()
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
	progress_bar.value = GameManager.healthBoss
	label.text = str(GameManager.healthBoss) + " / " + str(progress_bar.max_value)
	if progress_bar.value <= 0:
		#TODO hacer que el boss se muera
		print("ganaste")

func updateShield():
	progressBarShield.max_value = shieldMaxValue
	progressBarShield.value = GameManager.bossShield
	labelShield.text = str(GameManager.bossShield) + " / " + str(shieldMaxValue)

func initShield():
	GameManager.bossShield = shieldMaxValue
	progressBarShield.value = shieldMaxValue
	labelShield.text = str(GameManager.bossShield) + " / " + str(shieldMaxValue)
	progressBarShield.visible = true

func removeShield():
	progressBarShield.visible = false
	GameManager.bossShield = 0
