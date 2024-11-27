extends Control

var numCardsBoard = 7
var finalCardList: Array
var cardListSceneTemp
var cardListSpecialSceneTemp
var bossOXTemp
var bossCobraTemp
var clicks = 0

@export var maxHealthPlayer = 200
@export var shieldMaxValue = 50
@export var numSpecial = 2

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var grid: GridContainer = $BoardContainer/CenterContainer/grid
@onready var grid_container: GridContainer = $BossContainer/CenterContainer/GridContainer
@onready var progressBarShield: ProgressBar = $ProgressBarShield
@onready var resetBoard: Button = $ResetBoard
@onready var timerDamage: Timer = $ProgressBar/Timer
@onready var damage_bar: ProgressBar = $ProgressBar/DamageBar
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var historialContainer: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var border: Sprite2D = $ProgressBar/Border
@onready var text_edit: LineEdit = $TextEdit
@onready var history_title: Label = $ColorRect2/HistoryTitle

@onready var fire_reroll = $Sounds/SFX/FireReroll
@onready var getting_hit = $Sounds/SFX/GettingHit

# Cargamos la escena que contiene todas las cartas
@onready var cardListScene = preload("res://scenes/cardList.tscn")
@onready var cardListSpecialScene = preload("res://scenes/cardListSpecial.tscn")
@onready var bossOX = preload("res://scenes/OX.tscn")
@onready var bossCobra = preload("res://scenes/cobra.tscn")
@onready var pause_menu = $PauseMenu

func _ready():
	text_edit.visible = false
	pause_menu.visible = false
	
	GameManager.numCombat += 1
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
	GameManager.FlipTwoCard.connect(flipTwoCard)
	GameManager.UpdateHistorial.connect(updateHistorial)
	GameManager.isBossTurn.connect(quitPlayerHealthBorderShader)
	GameManager.isPlayerTurn.connect(putPlayerHealthBorderShader)
	
	bossOXTemp = bossOX.instantiate()
	bossCobraTemp = bossCobra.instantiate()
	
	#Seleccionamos el boss teniendo en cuenta la eleccion del jugador en la narrativa
	selectBoss()
	
	# Instanciamos la lista
	cardListSceneTemp = cardListScene.instantiate()
	cardListSpecialSceneTemp = cardListSpecialScene.instantiate()
	GameManager.BoardCompleted.connect(restartBoard)
	initBoard()

func initBoard():
	GameManager.doubleShift = true
	# Metemos la lista para comprobar sus hijos
	add_child(cardListSceneTemp)
	cardListSceneTemp.visible = false
	# Almacenamos todos los nodos(cartas) para mezclarlas
	var cardList = cardListSceneTemp.get_children()
	
	add_child(cardListSpecialSceneTemp)
	cardListSpecialSceneTemp.visible = false
	# Almacenamos todos los nodos(cartas) para mezclarlas
	var cardListSpecial = cardListSpecialSceneTemp.get_children()
	
	cardList.shuffle()
	
	# Seleccionamos 8 cartas del pull y las guardamos
	for k in range(numCardsBoard):
		finalCardList.append(cardList[k])
		
	finalCardList += finalCardList
	
	for i in range(numSpecial):
		finalCardList.append(cardListSpecial[i])
	
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
	resetBoard.disabled = true
	fire_reroll.play()
	finalCardList = []
	GameManager.BurnCards.emit()
	await get_tree().create_timer(1.5).timeout
	clearBoard()
	initBoard()
	GameManager.doubleShift = true

func UpdateProgressBar():
	getting_hit.play()
	timerDamage.start()
	progress_bar.value = GameManager.healthPlayer
	if progress_bar.value <= 0:
		#TODO hacer que el player se muera
		GameManager.resetBossScene()
		GameManager.numCombat = 0
		get_tree().change_scene_to_file.bind("res://scenes/menus/game_over/game_over.tscn").call_deferred()

func selectBoss():
	if Dialogic.VAR.ox_selected:
		# Metemos la lista para comprobar sus hijos
		add_child(bossOXTemp)
		
		# Almacenamos todos los nodos (cartas) para mezclarlas
		var boss = bossOXTemp.get_children()
		
		# Seleccionamos el jefe basado en el número de jefe elegido
		GameManager.pickedBoss = boss[0]
		
		# Añadimos el jefe duplicado al grid
		grid_container.add_child(GameManager.pickedBoss)
		Dialogic.VAR.ox_selected = false
		Dialogic.VAR.cobra_selected = true
		return
	
	if Dialogic.VAR.cobra_selected:
		# Metemos la lista para comprobar sus hijos
		add_child(bossCobraTemp)
		
		# Almacenamos todos los nodos (cartas) para mezclarlas
		var boss = bossCobraTemp.get_children()
		
		# Seleccionamos el jefe basado en el número de jefe elegido
		GameManager.pickedBoss = boss[0]
		
		# Añadimos el jefe duplicado al grid
		grid_container.add_child(GameManager.pickedBoss)
		Dialogic.VAR.cobra_selected = false
		Dialogic.VAR.ox_selected = true
		return

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

func flipTwoCard():
	var cardNoFlip: Array
	var card1
	var card2
	for i in grid.get_child_count():
		var child = grid.get_child(i)
		if child.isFlipped == false:
			cardNoFlip.append(child)
	
	if cardNoFlip != null:
		cardNoFlip.shuffle()
		card1 = cardNoFlip[0]
		card2 = cardNoFlip[1]
	
	await get_tree().create_timer(0.5).timeout
	card1.mostrarFace()
	card2.mostrarFace()

func updateHistorial(text, boss):
	var new_label = Label.new()
	new_label.text = text
	new_label.add_theme_font_size_override("font_size", 12)
	var font_color_white = Color(0,0,0)
	new_label.add_theme_color_override("font_color", font_color_white)
	
	if boss:
		var font_color = Color(0.682, 0.141, 0.133)
		new_label.add_theme_color_override("font_color", font_color)
	
	historialContainer.add_child(new_label)
	historialContainer.move_child(new_label, 0)

func quitPlayerHealthBorderShader():
	border.material.set_shader_parameter("isHighlight", false)

func putPlayerHealthBorderShader():
	border.material.set_shader_parameter("isHighlight", true)

func _on_pause_pressed() -> void:
	pause_menu.visible = true

func _on_reset_board_pressed() -> void:
	GameManager.firstCardPicked = null
	GameManager.secondCardPicked = null
	GameManager.countCouple = 0
	if GameManager.canFlip:
		GameManager.BoardCompleted.emit()

func _on_timer_timeout() -> void:
	damage_bar.value = GameManager.healthPlayer

func _on_btn_cheat_pressed() -> void:
	clicks += 1
	print(clicks)
	if clicks >= 5:
		text_edit.visible = true

func _on_text_edit_text_submitted(new_text: String) -> void:
	if new_text == "flip":
		flipAllCards()
		text_edit.visible = true
	
	if new_text == "kill":
		killBoss()
	
	if new_text == "reshuffle":
		reshuffle()
	
	text_edit.text = ""
	text_edit.visible = false

func flipAllCards():
	var cardNoFlip: Array
	for i in grid.get_child_count():
		var child = grid.get_child(i)
		if child.isFlipped == false:
			cardNoFlip.append(child)
	
	if cardNoFlip != null:
		for k in cardNoFlip:
			k.mostrarFace()

func killBoss():
	GameManager.healthBoss = 0
	GameManager.BossTakeDamage.emit()

func reshuffle():
	GameManager.firstCardPicked = null
	GameManager.secondCardPicked = null
	GameManager.countCouple = 0
	if GameManager.canFlip:
		GameManager.BoardCompleted.emit()

func _on_btn_cheat_mouse_entered() -> void:
	history_title.add_theme_font_size_override("font_size", 20)

func _on_btn_cheat_mouse_exited() -> void:
	history_title.add_theme_font_size_override("font_size", 16)
