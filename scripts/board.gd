extends Control

var numCardsBoard = 8

# Cargamos la escena que contiene todas las cartas
@onready var cardListScene = preload("res://scenes/cardList.tscn")

func _ready():
	initBoard()

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func initBoard():
	# Instanciamos la lista
	var cardListSceneTemp = cardListScene.instantiate()
	var finalCardList: Array
	
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
		$grid.add_child(cardTemp)
		
	
