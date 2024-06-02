extends Node

var deathBattle : bool = false
var hardMode : bool = false
var startScene : String
var choice : bool

var isImmortal : bool = false
var playerDead : bool = false
var playerHP : float = 10.0
var isInvulnerable : bool = false
var inSpikes : int = 0

var isDeathWorld : bool = false

var playerCanMove = true

var canChangeWorlds = true

var courageMultiplier = 1
var isLastStand = false

var lastStandDrain = 3

var courage: float = 50.0 :
	get:
		return courage
	set(value):
		var oldCourage = courage
		print(courageMultiplier)
		courage = value
		if courage > 100:
			courage = 100
		if courage <= 0: 
			courage = 0
			Events.courage_depleted.emit()
		if oldCourage == 0 and courage > 0:
			Events.courage_restored.emit()
		if (oldCourage < min_courage_dash && courage >= min_courage_dash):
			is_dash_ready = true

var normalWorld : bool = true

# sword ui
var attack_buffer : int = 3
var outer_timer_time : float = 0.0
var is_sword_combo_active : bool = false

# courage ui
var min_courage_dash = 65:
	set(value):
		if (value == 55):
			Events.dash_threshold_change.emit()
		min_courage_dash = value

		
var dash_cooldown = 2:
	set(value):
		dash_cooldown = value
		is_dash_ready = true
		Events.dash_cooldown_change.emit(value)
		print("Send")

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

# Play test metrics
var n_deaths : int
var run_time : float
var play_time : float
var living_world_t : float
var total_living_world_t : float
var death_world_t : float
var total_death_world_t : float
var goblins_killed : int
var total_goblins_killed : int
var archers_killed : int
var total_archers_killed : int

func take_damage(damage_value : int, enemy : bool):
	if (not enemy):
		if not isLastStand:
			playerHP -= damage_value
			if playerHP <= 0:
				playerDead = true
			Events.took_damage.emit(enemy)
		else:
			courage -= 10
			if courage <= 0:
				playerDead = true
			Events.took_damage.emit(enemy)
		
	if(not isInvulnerable):
		if not isLastStand:
			playerHP -= damage_value
			if playerHP <= 0:
				playerDead = true
			Events.took_damage.emit(enemy)
		else:
			courage -= 10
			if courage <= 0:
				playerDead = true
			Events.took_damage.emit(enemy)

		
func set_courage(value : int):
	print(courageMultiplier)
	if (value > 0):
		courage += value * courageMultiplier
	else:
		courage += value

		

