extends Node

var playerHP : float = 10.0
#var courage : float = 50.0

var courage: float = 50.0 :
	get:
		return courage
	set(value):
		var oldCourage = courage
		courage = value
		if courage <= 0: 
			courage = 0
			Events.courage_depleted.emit()
		if oldCourage == 0 and courage > 0:
			Events.courage_restored.emit()

var normalWorld : bool = true

var maxHP : float = 10.0
var minHP : float = 0.0

var maxCourage : float = 100.0
var minCourage : float = 0.0

var maxSat : float = 1.2
var minSat : float = 0.3

var maxBri : float = 0
var minBri : float = -0.3

var redColor : Color = Color(30, 0, 0)
var whiteColor : Color = Color(30, 30, 30)
var blackColor : Color = Color(0, 0, 0)
