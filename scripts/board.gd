extends Control

# Cargamos la escena que contiene todas las cartas
@onready var cardListScene = preload("res://scenes/cardList.tscn")

func _ready():
	# Instanciamos la lista
	var cardListSceneTemp = cardListScene.instantiate()
	add_child(cardListSceneTemp)
	cardListSceneTemp.visible = false
	var cardList = cardListSceneTemp.get_children()
	cardList += cardList
	cardList.shuffle()
	
	for i in cardList:
		var cardTemp = i.duplicate()
		$grid.add_child(cardTemp)
		
	print($grid.get_children())
		

	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
