extends Control

@onready var warning = $Warning
@onready var cards = $Cards
@onready var bosses = $Bosses
@onready var backgrounds = $Backgrounds

func _ready():
	pass


func _on_cards_pressed():
		warning.hide()
		bosses.hide()
		backgrounds.hide()
		cards.show()
		
func _on_bosses_pressed():
		warning.hide()
		bosses.show()
		backgrounds.hide()
		cards.hide()
		
func _on_backgrounds_pressed():
		warning.hide()
		bosses.hide()
		backgrounds.show()
		cards.hide()
