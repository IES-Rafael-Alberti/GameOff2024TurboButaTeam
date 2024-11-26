extends Control

@onready var warning_label: Label = $WarningLabel
@onready var cards_label: Label = $CardsLabel
@onready var bosses_label: Label = $BossesLabel
@onready var bg_label: Label = $BGLabel
@onready var wiki_h_box: Node = $WikiHBox
@onready var texture: TextureRect = $WikiHBox/CenterContainer/Texture

@export var cardImgList: Array[Texture] = []
@export var bossImgList: Array[Texture] = []
@export var bgImgList: Array[Texture] = []

var current_index_card: int = 0
var current_index_boss: int = 0
var current_index_bg: int = 0

func _ready():
	warning_label.visible = true

func _on_cards_pressed():
	warning_label.visible = false
	bosses_label.visible = false
	bg_label.visible = false
	cards_label.visible = true
	
	if cardImgList.size() > 0:
		update_image()

func _on_bosses_pressed():
	warning_label.visible = false
	bosses_label.visible = true
	bg_label.visible = false
	cards_label.visible = false
	
	if bossImgList.size() > 0:
		update_image()

func _on_backgrounds_pressed():
	warning_label.visible = false
	bosses_label.visible = false
	bg_label.visible = true
	cards_label.visible = false
	
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
	
	if bosses_label.visible:
		texture.texture = bossImgList[current_index_boss]
	
	if bg_label.visible:
		texture.texture = bgImgList[current_index_bg]


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
