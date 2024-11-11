extends Control

var numCardsBoard = 8
var finalCardList: Array
var cardListSceneTemp
@export var maxHealthPlayer = 200

@onready var grid = $VBoxContainer/CenterContainer/grid
@onready var progress_bar: ProgressBar = $ProgressBar


# Cargamos la escena que contiene todas las cartas
@onready var cardListScene = preload("res://scenes/cardList.tscn")

func _ready():
	#Ponerle la vida al player
	GameManager.healthPlayer = maxHealthPlayer
	progress_bar.max_value = GameManager.healthPlayer
	progress_bar.value = GameManager.healthPlayer
	
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
