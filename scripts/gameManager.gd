extends Node

#Variable con la vida del boss
var healthBoss

#Variable con la vida del jugador
var healthPlayer

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

#Senal para ver cuando se hace dano
signal BossTakeDamage
