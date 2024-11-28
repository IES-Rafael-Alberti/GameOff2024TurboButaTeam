extends Node

#Variable con la vida del boss
var healthBoss

#Variable con la vida del jugador
var healthPlayer

#Variable con el escudo del jugador
var playerShield = 0

#Variable con el escudo del boss
var bossShield = 0

#Hace un preload del dorso de la carta
var cardBack = preload("res://assets/sprites/cards/reverso.png")

#Guarda el nodo de la primera carta
var firstCardPicked

#Guarda el nodo de la segunda carta
var secondCardPicked

#Para comprobar si la carta ya está girada
var canFlip = true

#Contador de parejas, si llega a 8 se vuelve a 0
var countCouple = 0

#Gestionar los turnos
var isPlayerPhase = true

var numCombat = 0

var isFinalCinematic = false

#Senal para volver a llenar el tablero
signal BoardCompleted

#Senal para ver cuando se hace dano al boss
signal BossTakeDamage

#Senal para ver cuando se hace dano al player
signal PlayerTakeDamage

#Senal para ver cuando se hace dano al player
signal PlayerShield

signal QuitPlayerShield

signal InitPlayerShield

signal BurnCards

signal BurnCardsInit

signal BossShield

signal QuitBossShield

signal InitBossShield

signal SelectActionBoss

signal restartButtonVisible

signal isBossTurn

signal isPlayerTurn

var bossIsCharging = false

signal EightyOfLife

signal SixtyOfLife

signal FortyOfLife

signal TwentyOfLife

signal TenOfLife

signal UpdateHistorial(text, boss)

signal FlipTwoCard

signal TurnBoss

var isPoisoned = false

#Multi de daño que se vuelve a poner en 1 cuando el boss muere
var damageMultiply = 1

var pickedBoss

#Esta variable es la que hay que usar en el dialogo para saber que boss a seleccionado
var bossNum = 0

var doubleShift = true

var isCouple = false

var specialCard

func resetBossScene():
	firstCardPicked = null
	secondCardPicked = null
	countCouple = 0
	damageMultiply = 1
	isPoisoned = false
	bossIsCharging = false
	isPlayerPhase = true
	canFlip = true
