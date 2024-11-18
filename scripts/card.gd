extends TextureButton

@export var face = Texture
@export var scriptAnimal: Script
@onready var animationPlayer = $AnimationPlayer

var back
var isFlipped = false
var countCouple = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	back = GameManager.cardBack
	set_texture_normal(back)

func voltear():
	if isFlipped == false:
		animationPlayer.play("flip")
		await get_tree().create_timer(0.3).timeout
		set_texture_normal(face)
		isFlipped = true
	else:
		set_texture_normal(back)
		isFlipped = false
		
	
func _on_pressed():
		
	if isFlipped == false && GameManager.canFlip && GameManager.isPlayerPhase:
		voltear()
		isFlipped = true

		if !GameManager.firstCardPicked:
				GameManager.firstCardPicked = self
				GameManager.QuitPlayerShield.emit()
				GameManager.canFlip = false
				await get_tree().create_timer(0.6).timeout
				GameManager.canFlip = true
		elif GameManager.firstCardPicked && !GameManager.secondCardPicked:
				GameManager.secondCardPicked = self 
				GameManager.canFlip = false
				await get_tree().create_timer(0.6).timeout
				GameManager.canFlip = true
				isEqual(GameManager.firstCardPicked , GameManager.secondCardPicked)
				GameManager.isPlayerPhase = false
			
	

func isEqual(firstCard, secondCard):

	if firstCard.get_texture_normal() != secondCard.get_texture_normal():
		firstCard.voltear()
		secondCard.voltear()
	else:
		GameManager.countCouple += 1
		#TODO hacer que se realice la accion de las cartas flipeadas
		var finalScriptAnimal = scriptAnimal.new()
		finalScriptAnimal.action()
	
	if GameManager.countCouple == 8:
		GameManager.BoardCompleted.emit()
		GameManager.countCouple = 0
	GameManager.firstCardPicked = null
	GameManager.secondCardPicked = null
		
