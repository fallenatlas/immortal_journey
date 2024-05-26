extends Node

var hardMode : bool = false

var isImmortal : bool = false;
var playerDead : bool = false
var playerHP : float = 10.0
var isInvulnerable : bool = false
var inSpikes : int = 0

var isDeathWorld : bool = false

var playerCanMove = true

var canChangeWorlds = true

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

# sword ui
var attack_buffer : int = 3
var outer_timer_time : float = 0.0
var is_sword_combo_active : bool = false

# courage ui
const MIN_COURAGE_DASH = 65
var dash_recharge_time : float = 0.0
var is_dash_ready : bool = true

var maxHP : float = 10.0
var minHP : float = 0.0

var maxCourage : float = 100.0
var minCourage : float = 0.0

var maxSat : float = 1.2
var minSat : float = 0.1

var maxBri : float = 0
var minBri : float = -0.4

var redColor : Color = Color(255, 0, 0)
var whiteColor : Color = Color(0, 0, 0)
var blackColor : Color = Color(0, 0, 0)
var softRedColor : Color = Color(100, 0, 0)


func take_damage(damage_value : int, enemy : bool):
	if (not enemy):
		playerHP -= damage_value
		if playerHP <= 0:
			playerDead = true
		Events.took_damage.emit(enemy)
		
	if(not isInvulnerable):
		playerHP -= damage_value
		if playerHP <= 0:
			playerDead = true
		Events.took_damage.emit(enemy)

