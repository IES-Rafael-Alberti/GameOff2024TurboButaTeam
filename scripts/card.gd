extends TextureButton

@export var face = Texture
var back
var isFlipped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	back = GameManager.cardBack
	set_texture_normal(back)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func voltear():
	if isFlipped == false:
		set_texture_normal(face)
		isFlipped = true
	else:
		set_texture_normal(back)
		isFlipped = false
		
	
func _on_pressed():
		
	if isFlipped == false && GameManager.canFlip:
		voltear()
		isFlipped = true

		if !GameManager.firstCardPicked:
				GameManager.firstCardPicked = self
		elif GameManager.firstCardPicked && !GameManager.secondCardPicked:
				GameManager.secondCardPicked = self 
				GameManager.canFlip = false
				await get_tree().create_timer(0.5).timeout
				GameManager.canFlip = true
				isEqual(GameManager.firstCardPicked , GameManager.secondCardPicked)
			
	

func isEqual(firstCard, secondCard):
	if firstCard.get_texture_normal() != secondCard.get_texture_normal():
		firstCard.voltear()
		secondCard.voltear()
	GameManager.firstCardPicked = null
	GameManager.secondCardPicked = null
		

