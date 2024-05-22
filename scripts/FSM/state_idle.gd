extends State
class_name PlayerIdle


var rng = RandomNumberGenerator.new()

func Enter():
	anim.play("Idle")
	
func Update(delta: float):
	
	var rand = rng.randi_range(0, 1)
	var isRangedRange = len(rangedAttackDetection.get_overlapping_bodies()) > 0
	var isMeleeRange = len(attackDetection.get_overlapping_bodies()) > 0
	
	if isMeleeRange and attackCooldown.is_stopped():
		
		#Is melee range but still does ranged attack
		if rand == 0:
			rand = rng.randi_range(0, 1)
			if isRangedRange and attackCooldown.is_stopped():
				if rand == 0:
					fsmManager.change_state(self, "Attack1")
				elif rand == 1:
					#fsmManager.change_state(self, "Attack3")
					pass
					
		#Is melee attack and does melee attack
		else:
			if attackCooldown.is_stopped():
					fsmManager.change_state(self, "Attack2")
					pass
					
	#Player is not inside melee range
	elif !isMeleeRange and attackCooldown.is_stopped():
		
		if isRangedRange and attackCooldown.is_stopped():
			if rand == 0:
				fsmManager.change_state(self, "Attack1")
			elif rand == 1:
				#fsmManager.change_state(self, "Attack3")
				pass
	elif !attackCooldown.is_stopped():
		#Run or something
		pass

func Exit():
	pass
