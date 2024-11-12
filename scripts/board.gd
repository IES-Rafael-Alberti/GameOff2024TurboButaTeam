extends Control

var numCardsBoard = 8
var finalCardList: Array
var cardListSceneTemp
var bossListSceneTemp

@export var maxHealthPlayer = 200

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var grid: GridContainer = $BoardContainer/CenterContainer/grid
@onready var grid_container: GridContainer = $BossContainer/CenterContainer/GridContainer


# Cargamos la escena que contiene todas las cartas
@onready var cardListScene = preload("res://scenes/cardList.tscn")
@onready var bossListScene = preload("res://scenes/bossList.tscn")

func _ready():
	#Ponerle la vida al player
	GameManager.healthPlayer = maxHealthPlayer
	progress_bar.max_value = GameManager.healthPlayer
	progress_bar.value = GameManager.healthPlayer
	
	GameManager.PlayerTakeDamage.connect(UpdateProgressBar)
	
	bossListSceneTemp = bossListScene.instantiate()
	
	#Seleccionamos el boss teniendo en cuenta la eleccion del jugador en la narrativa
	selectBoss()
	
	# Instanciamos la lista
	cardListSceneTemp = cardListScene.instantiate()
	GameManager.BoardCompleted.connect(restartBoard)
	initBoard()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
		

func clearBoard():
	var cardsInGrid = grid.get_children()
	for i in cardsInGrid:
		grid.remove_child(i)

func restartBoard():
	finalCardList = []
	clearBoard()
	initBoard()


func UpdateProgressBar():
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
	
	print(bossList)
	
	GameManager.pickedBoss = bossList[GameManager.bossNum]
	
	var bossTemp = GameManager.pickedBoss.duplicate()
	
	grid_container.add_child(bossTemp)
