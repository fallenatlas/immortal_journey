extends State
class_name PlayerAttack2



func Enter():
	anim.play("Attack2")
	attackCooldown.start()
	
func Update(delta: float):
	pass

func Exit():
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack2":
		fsmManager.change_state(self, "Idle")
