extends Node

signal switch_world(normalWorld : bool)

signal courage_depleted
signal courage_restored

signal took_damage(enemy : bool)

signal dash_cooldown_change(value : float)

signal dash_threshold_change()

signal attack_cooldown_change(value : float)

signal unlock_upgrade(number : int)

signal cutscene_finished()

signal died_in_boss()

signal last_stand()

signal final_choice()
