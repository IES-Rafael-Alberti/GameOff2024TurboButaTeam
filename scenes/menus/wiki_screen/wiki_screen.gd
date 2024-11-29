extends Control

@onready var warning_label: Label = $WarningLabel
@onready var cards_label: Label = $CardsLabel
@onready var bosses_label: Label = $BossesLabel
@onready var bg_label: Label = $BGLabel
@onready var wiki_h_box: Node = $WikiHBox
@onready var texture: TextureRect = $WikiHBox/CenterContainer/Texture
@onready var info_panel: Control = $WikiHBox/infoPanel
@onready var nombre: Label = $WikiHBox/infoPanel/nombre
@onready var dato: Label = $WikiHBox/infoPanel/ScrollContainer/VBoxContainer/dato
@onready var utilidad: Label = $WikiHBox/infoPanel/ScrollContainer/VBoxContainer/utilidad
@onready var card_credits: Label = $CardCredits
@onready var boss_credits: Label = $BossCredits
@onready var bg_credits: Label = $BgCredits
@onready var card_button: Button = $WikiHBox/CardButton
@onready var button_2: Button = $WikiHBox/Button2

@export var cardImgList: Array[Texture] = []
@export var bossImgList: Array[Texture] = []
@export var bgImgList: Array[Texture] = []

@export var cardNameList: Array[String] = []
@export var bossNameList: Array[String] = []
@export var bgNameList: Array[String] = []

@export var cardTextList: Array[String] = []
@export var bossTextList: Array[String] = []
@export var bgTextList: Array[String] = []

@export var cardHabilityList: Array[String] = []
@export var bossHabilityList: Array[String] = []

@export var cardCreditsList: Array[String] = []
@export var bossCreditsList: Array[String] = []
@export var bgCreditsList: Array[String] = []

var current_index_card: int = 0
var current_index_boss: int = 0
var current_index_bg: int = 0

func _ready():
	warning_label.visible = true
	info_panel.visible = false
	card_credits.visible = false
	boss_credits.visible = false
	bg_credits.visible = false
	nombre.visible = false
	dato.visible = false
	utilidad.visible = false
	card_button.visible = false
	button_2.visible = false

func _on_cards_pressed():
	warning_label.visible = false
	bosses_label.visible = false
	bg_label.visible = false
	cards_label.visible = true
	info_panel.visible = true
	card_credits.visible = true
	boss_credits.visible = false
	bg_credits.visible = false
	nombre.visible = true
	dato.visible = true
	utilidad.visible = true
	card_button.visible = true
	button_2.visible = true
	
	if cardImgList.size() > 0:
		update_image()

func _on_bosses_pressed():
	warning_label.visible = false
	bosses_label.visible = true
	bg_label.visible = false
	cards_label.visible = false
	info_panel.visible = true
	card_credits.visible = false
	boss_credits.visible = true
	bg_credits.visible = false
	nombre.visible = true
	dato.visible = true
	utilidad.visible = true
	card_button.visible = true
	button_2.visible = true
	
	if bossImgList.size() > 0:
		update_image()

func _on_backgrounds_pressed():
	warning_label.visible = false
	bosses_label.visible = false
	bg_label.visible = true
	cards_label.visible = false
	info_panel.visible = true
	card_credits.visible = false
	boss_credits.visible = false
	bg_credits.visible = true
	nombre.visible = true
	dato.visible = true
	utilidad.visible = false
	card_button.visible = true
	button_2.visible = true
	
	if bgImgList.size() > 0:
		update_image()

# Cambiar a la imagen anterior
func _on_left_arrow_pressed():
	if cards_label.visible:
		if cardImgList.size() > 0:
			current_index_card = (current_index_card - 1 + cardImgList.size()) % cardImgList.size()
			update_image()
	
	if bosses_label.visible:
		if bossImgList.size() > 0:
			current_index_boss = (current_index_boss - 1 + bossImgList.size()) % bossImgList.size()
			update_image()
	
	if bg_label.visible:
		if bgImgList.size() > 0:
			current_index_bg = (current_index_bg - 1 + bgImgList.size()) % bgImgList.size()
			update_image()

# Cambiar a la siguiente imagen
func _on_right_arrow_pressed():
	if cards_label.visible:
		if cardImgList.size() > 0:
			current_index_card = (current_index_card + 1) % cardImgList.size()
			update_image()
	
	if bosses_label.visible:
		if bossImgList.size() > 0:
			current_index_boss = (current_index_boss + 1) % bossImgList.size()
			update_image()
	
	if bg_label.visible:
		if bgImgList.size() > 0:
			current_index_bg = (current_index_bg + 1) % bgImgList.size()
			update_image()

# Actualizar la textura mostrada
func update_image():
	if cards_label.visible:
		texture.texture = cardImgList[current_index_card]
		nombre.text = cardNameList[current_index_card]
		dato.text = cardTextList[current_index_card]
		utilidad.text = cardHabilityList[current_index_card]
		card_credits.text = cardCreditsList[current_index_card]
	
	if bosses_label.visible:
		card_credits.visible = false
		boss_credits.visible = true
		texture.texture = bossImgList[current_index_boss]
		nombre.text = bossNameList[current_index_boss]
		dato.text = bossTextList[current_index_boss]
		utilidad.text = bossHabilityList[current_index_boss]
		boss_credits.text = bossCreditsList[current_index_boss]
		if current_index_boss == 2:
			boss_credits.visible = false
			card_credits.visible = true
			card_credits.text = bossCreditsList[current_index_bg]
		else:
			boss_credits.text = bossCreditsList[current_index_bg]
	
	if bg_label.visible:
		texture.texture = bgImgList[current_index_bg]
		nombre.text = bgNameList[current_index_bg]
		dato.text = bgTextList[current_index_bg]
		bg_credits.text = bgCreditsList[current_index_bg]

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
