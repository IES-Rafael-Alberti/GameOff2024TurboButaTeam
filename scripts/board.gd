extends Control

var numCardsBoard = 8
var finalCardList: Array
var cardListSceneTemp
var bossListSceneTemp

@export var maxHealthPlayer = 200
@export var shieldMaxValue = 50

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var grid: GridContainer = $BoardContainer/CenterContainer/grid
@onready var grid_container: GridContainer = $BossContainer/CenterContainer/GridContainer
@onready var progressBarShield: ProgressBar = $ProgressBarShield
@onready var resetBoard: Button = $ResetBoard
@onready var timerDamage: Timer = $ProgressBar/Timer
@onready var damage_bar: ProgressBar = $ProgressBar/DamageBar

@onready var fire_reroll = $Sounds/SFX/FireReroll
@onready var getting_hit = $Sounds/SFX/GettingHit

# Cargamos la escena que contiene todas las cartas
@onready var cardListScene = preload("res://scenes/cardList.tscn")
@onready var bossListScene = preload("res://scenes/bossList.tscn")

func _ready():
	#Ponerle la vida al player
	GameManager.healthPlayer = maxHealthPlayer
	progress_bar.max_value = GameManager.healthPlayer
	progress_bar.value = GameManager.healthPlayer
	damage_bar.max_value = GameManager.healthPlayer
	damage_bar.value = GameManager.healthPlayer
	#Quitar visible al shield del player
	progressBarShield.visible = false
	
	#Quitar visible al boton de reset
	resetBoard.disabled = true
	
	GameManager.PlayerTakeDamage.connect(UpdateProgressBar)
	GameManager.PlayerShield.connect(updateShield)
	GameManager.InitPlayerShield.connect(initShield)
	GameManager.QuitPlayerShield.connect(removeShield)
	GameManager.restartButtonVisible.connect(restartButtonVisible)
	
	bossListSceneTemp = bossListScene.instantiate()
	
	#Seleccionamos el boss teniendo en cuenta la eleccion del jugador en la narrativa
	selectBoss()
	
	# Instanciamos la lista
	cardListSceneTemp = cardListScene.instantiate()
	GameManager.BoardCompleted.connect(restartBoard)
	initBoard()

func initBoard():
	# Metemos la lista para comprobar sus hijos
	add_child(cardListSceneTemp)
	cardListSceneTemp.visible = false
	# Almacenamos todos los nodos(cartas) para mezclarlas
	var cardList = cardListSceneTemp.get_children()
	cardList.shuffle()
	
	# Seleccionamos 8 cartas del pull y las guardamos
	for k in range(numCardsBoard):
		finalCardList.append(cardList[k])
		
	finalCardList += finalCardList
	finalCardList.shuffle()
	
	# Tiramos las cartas al grid
	for i in finalCardList:
		var cardTemp = i.duplicate()
		grid.add_child(cardTemp)
		
	GameManager.BurnCardsInit.emit()

func clearBoard():
	var cardsInGrid = grid.get_children()
	for i in cardsInGrid:
		grid.remove_child(i)

func restartBoard():
	fire_reroll.play()
	finalCardList = []
	GameManager.BurnCards.emit()
	await get_tree().create_timer(1.5).timeout
	clearBoard()
	initBoard()
	GameManager.doubleShift = true
	resetBoard.disabled = true

func UpdateProgressBar():
	getting_hit.play()
	timerDamage.start()
	progress_bar.value = GameManager.healthPlayer
	if progress_bar.value <= 0:
		#TODO hacer que el player se muera
		print("perdiste")

func selectBoss():
	# Metemos la lista para comprobar sus hijos
	add_child(bossListSceneTemp)
	bossListSceneTemp.visible = false
	# Almacenamos todos los nodos(cartas) para mezclarlas
	var bossList = bossListSceneTemp.get_children()
	
	bossList.shuffle()
	
	#GameManager.pickedBoss = bossList[GameManager.bossNum]
	#He cambiado esto para la primera demo, para que siempre salga el buey
	GameManager.pickedBoss = bossList[0]
	GameManager.pickedBoss = bossList[GameManager.bossNum]
	
	var bossTemp = GameManager.pickedBoss.duplicate()
	
	grid_container.add_child(bossTemp)

func updateShield():
	progressBarShield.max_value = shieldMaxValue
	progressBarShield.value = GameManager.playerShield

func initShield():
	GameManager.playerShield = shieldMaxValue
	progressBarShield.visible = true

func removeShield():
	progressBarShield.visible = false
	GameManager.playerShield = 0

func restartButtonVisible():
	resetBoard.disabled = false

func _on_button_pressed() -> void:
	GameManager.BoardCompleted.emit()


func _on_timer_timeout() -> void:
	damage_bar.value = GameManager.healthPlayer
