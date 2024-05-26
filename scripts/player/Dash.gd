extends Node2D

@onready var cooldown_timer = $"Dash Cooldown"
@onready var dash_timer = $"Dash Time"
@onready var effect_timer = $"Effect Timer"

func start_dash():
	Game.is_dash_ready = false
	Game.dash_recharge_time = 0.0
	cooldown_timer.start();
	dash_timer.start();
	
func start_dash_effect():
	effect_timer.start();
	
func is_cooldown():
	return cooldown_timer.is_stopped();
	
func is_dashing():
	return !dash_timer.is_stopped();
	
func is_effect_cooldown():
	return effect_timer.is_stopped();
	
func _process(delta):
	if !cooldown_timer.is_stopped():
		var value = cooldown_timer.wait_time - cooldown_timer.time_left
		Game.dash_recharge_time = value if value >= 0.1 else 0.0

func _on_dash_cooldown_timeout():
	Game.is_dash_ready = true
