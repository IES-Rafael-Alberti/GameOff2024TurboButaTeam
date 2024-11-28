extends TextureButton

@export var face = Texture
@export var scriptAnimal: Script
@export var faceSpecial1 = Texture 
@export var faceSpecial2 = Texture 
@onready var animationPlayer = $AnimationPlayer
@onready var shadowAnimationPlayer = $Shadow/ShadowAnimationPlayer
@onready var bossTurnShadow: Sprite2D = $BossTurnShadow
@onready var bossTurnShadowAnimation: AnimationPlayer = $BossTurnShadow/BossTurnShadowAnimation

@onready var card_flip = $CardFlip

var back
var isFlipped = false
var countCouple = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	back = GameManager.cardBack
	set_texture_normal(back)
	GameManager.BurnCards.connect(burnCardsRestart)
	GameManager.BurnCardsInit.connect(burnCardsInit)
	GameManager.isBossTurn.connect(bossTurnShadowCards)
	
func voltear():
	if isFlipped == false:
		card_flip.play()
		animationPlayer.play("flip")
		shadowAnimationPlayer.play("flip")
		await get_tree().create_timer(0.2).timeout
		set_texture_normal(face)
		isFlipped = true
	else:
		animationPlayer.play("flip")
		shadowAnimationPlayer.play("flip")
		await get_tree().create_timer(0.2).timeout
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
				await get_tree().create_timer(0.4).timeout
				if isSpecialCard(GameManager.firstCardPicked):
					GameManager.specialCard.material.set_shader_parameter("isHighlight", true)
					await get_tree().create_timer(1).timeout
					GameManager.specialCard.material.set_shader_parameter("isHighlight", false)
					GameManager.specialCard = null
				
				GameManager.canFlip = true
		elif GameManager.firstCardPicked && !GameManager.secondCardPicked:
				GameManager.secondCardPicked = self 
				GameManager.canFlip = false
				await get_tree().create_timer(0.8).timeout
				if !isSpecialCard(GameManager.firstCardPicked, GameManager.secondCardPicked):
					isEqual(GameManager.firstCardPicked , GameManager.secondCardPicked)
					if(GameManager.isCouple):
						await get_tree().create_timer(1).timeout
						GameManager.isCouple = false
				else:
					GameManager.specialCard.material.set_shader_parameter("isHighlight", true)
					await get_tree().create_timer(1).timeout
					GameManager.specialCard.material.set_shader_parameter("isHighlight", false)
					GameManager.specialCard = null
				GameManager.canFlip = true
				
				if GameManager.doubleShift:
					GameManager.doubleShift = false
				else:
					GameManager.canFlip = false
					GameManager.isBossTurn.emit()
					await get_tree().create_timer(2).timeout
					GameManager.TurnBoss.emit()

func isEqual(firstCard, secondCard):
	if firstCard.get_texture_normal() != secondCard.get_texture_normal():
		firstCard.voltear()
		secondCard.voltear()
		GameManager.emit_signal("UpdateHistorial", "FAIL_EQUAL_HISTORY", false)
	else:
		GameManager.countCouple += 1
		GameManager.isCouple = true
		var finalScriptAnimal = scriptAnimal.new()
		finalScriptAnimal.action()
		#Activar el brillo de la pareja de cartas
		firstCard.material.set_shader_parameter("isHighlight", true)
		secondCard.material.set_shader_parameter("isHighlight", true)
	
	if GameManager.countCouple == 3:
		GameManager.restartButtonVisible.emit()
	
	GameManager.firstCardPicked = null
	GameManager.secondCardPicked = null
	
	await get_tree().create_timer(1).timeout
	#Desactivar el brillo de la pareja de cartas
	firstCard.material.set_shader_parameter("isHighlight", false)
	secondCard.material.set_shader_parameter("isHighlight", false)
		
	#TODO poner a 6 cuando tengamos todas las cartas
	if GameManager.countCouple == 6:
		GameManager.BoardCompleted.emit()
		GameManager.countCouple = 0
	

func burnCardsRestart():
	var cardShaderDissolveValue = self.material.get_shader_parameter("dissolve_value")
	var frames = 5
	
	for i in frames:
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		timer.autostart = true
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
		timer.autostart = true
		add_child(timer)
		timer.start()
		await timer.timeout
		cardShaderDissolveValue += 0.2
		self.material.set_shader_parameter("dissolve_value", cardShaderDissolveValue)
		timer.queue_free()
		

func burnCardsInit():
	var cardShaderDissolveValue = self.material.get_shader_parameter("dissolve_value")
	var frames = 5
	cardShaderDissolveValue = 0
	
	for i in frames:
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		timer.autostart = true
		add_child(timer)
		timer.start()
		await timer.timeout
		cardShaderDissolveValue += 0.2
		self.material.set_shader_parameter("dissolve_value", cardShaderDissolveValue)
		timer.queue_free()
		
		
	await get_tree().create_timer(1).timeout

func isSpecialCard(firstCard: Object = null, secondCard: Object = null) -> bool:
	if firstCard != null:
		if firstCard.get_texture_normal() == faceSpecial2 || firstCard.get_texture_normal() == faceSpecial1:
			var finalScriptAnimal = scriptAnimal.new()
			finalScriptAnimal.action()
			GameManager.specialCard = firstCard
			GameManager.firstCardPicked = null
			GameManager.secondCardPicked = null
			return true
	
	if secondCard != null:
		if secondCard.get_texture_normal() == faceSpecial2 || secondCard.get_texture_normal() == faceSpecial1:
			var finalScriptAnimal = scriptAnimal.new()
			finalScriptAnimal.action()
			firstCard.voltear()
			GameManager.specialCard = secondCard
			GameManager.firstCardPicked = null
			GameManager.secondCardPicked = null
			return true
	
	return false


func bossTurnShadowCards():
	bossTurnShadow.visible=true
	bossTurnShadowAnimation.play("isBossTurn")
	
func mostrarFace():
	card_flip.play()
	animationPlayer.play("flip")
	shadowAnimationPlayer.play("flip")
	await get_tree().create_timer(0.2).timeout
	set_texture_normal(face)
	self.modulate = Color(1.0, 1.0, 1.0, 0.78)


func _on_mouse_entered():
	self.scale = Vector2(1.1, 1.1)

func _on_mouse_exited():
	self.scale = Vector2(1, 1)
