extends Node2D


@onready var cooldown_timer = $"Dash Cooldown"
@onready var dash_timer = $"Dash Time"

func start_dash():
	cooldown_timer.start();
	dash_timer.start();
	
func is_cooldown():
	return cooldown_timer.is_stopped();
	
func is_dashing():
	return !dash_timer.is_stopped();

