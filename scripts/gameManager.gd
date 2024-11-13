extends Node

#Variable con la vida del boss
var healthBoss

#Variable con la vida del jugador
var healthPlayer

#Variable con la vida del jugador
var playerShield = 0

#Hace un preload del dorso de la carta
var cardBack = preload("res://assets/sprites/cards/cardBack.png")

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

#Senal para volver a llenar el tablero
signal BoardCompleted

#Senal para ver cuando se hace dano al boss
signal BossTakeDamage

#Senal para ver cuando se hace dano al player
signal PlayerTakeDamage

var bossIsCharging

#Multi de daño que se vuelve a poner en 1 cuando el boss muere
var damageMultiply = 1

var pickedBoss

#Esta variable es la que hay que usar en el dialogo para saber que boss a seleccionado
var bossNum = 0
