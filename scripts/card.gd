extends TextureButton

@export var face = Texture
@export var scriptAnimal: Script
@export var faceSpecial1 = Texture 
@export var faceSpecial2 = Texture 
@onready var animationPlayer = $AnimationPlayer

var back
var isFlipped = false
var countCouple = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(face)
	back = GameManager.cardBack
	set_texture_normal(back)
	GameManager.BurnCards.connect(burnCard)

	
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
				await get_tree().create_timer(1).timeout
				isSpecialCard(GameManager.firstCardPicked)
				GameManager.canFlip = true
		elif GameManager.firstCardPicked && !GameManager.secondCardPicked:
				GameManager.secondCardPicked = self 
				GameManager.canFlip = false
				await get_tree().create_timer(1.5).timeout
				if !isSpecialCard(GameManager.firstCardPicked, GameManager.secondCardPicked):
					isEqual(GameManager.firstCardPicked , GameManager.secondCardPicked)
				GameManager.canFlip = true
				
				if GameManager.doubleShift:
					GameManager.doubleShift = false
				else:
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
		

func burnCard():
	var cardShaderDissolveValue = self.material.get_shader_parameter("dissolve_value")
	var frames = 5
	
	for i in frames:
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		cardShaderDissolveValue -= 0.2
		self.material.set_shader_parameter("dissolve_value", cardShaderDissolveValue)
		timer.queue_free()
		
	await get_tree().create_timer(1).timeout
	
	for i in frames:
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		cardShaderDissolveValue += 0.2
		self.material.set_shader_parameter("dissolve_value", cardShaderDissolveValue)
		timer.queue_free()
		

func isSpecialCard(firstCard: Object = null, secondCard: Object = null) -> bool:
	if firstCard != null:
		if firstCard.get_texture_normal() == faceSpecial2 || firstCard.get_texture_normal() == faceSpecial1:
			var finalScriptAnimal = scriptAnimal.new()
			finalScriptAnimal.action()
			GameManager.firstCardPicked = null
			GameManager.secondCardPicked = null
			return true
	
	if secondCard != null:
		if secondCard.get_texture_normal() == faceSpecial2 || secondCard.get_texture_normal() == faceSpecial1:
			var finalScriptAnimal = scriptAnimal.new()
			finalScriptAnimal.action()
			firstCard.voltear()
			GameManager.firstCardPicked = null
			GameManager.secondCardPicked = null
			return true
	
	return false
