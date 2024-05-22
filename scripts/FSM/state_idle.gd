extends State
class_name PlayerIdle


var rng = RandomNumberGenerator.new()

func Enter():
	anim.play("Idle")
	
func Update(delta: float):
	
	var rand = rng.randi_range(0, 1)
	var isRangedRange = len(rangedAttackDetection.get_overlapping_bodies()) > 0
	var isMeleeRange = len(attackDetection.get_overlapping_bodies()) > 0
	var isJumpAttackRange = len(jumpAttackDetection.get_overlapping_bodies()) > 0
	
	if isMeleeRange and attackCooldown.is_stopped():
		
		#Is melee range but still does ranged attack
		if rand == 0:
			rand = rng.randi_range(0, 1)
			if isRangedRange and attackCooldown.is_stopped():
				if rand == 0:
					fsmManager.change_state(self, "Attack1")
				elif rand == 1:
					fsmManager.change_state(self, "Attack3")
					pass
					
		#Is melee attack and does melee attack
		else:
			if attackCooldown.is_stopped():
					fsmManager.change_state(self, "Attack2")
					pass
					
	#Player is not inside melee range nor jump attack range
	elif !isMeleeRange and !isJumpAttackRange and attackCooldown.is_stopped():
		
		if isRangedRange and attackCooldown.is_stopped():
			if rand == 0:
				fsmManager.change_state(self, "Attack1")
			elif rand == 1:
				fsmManager.change_state(self, "Attack3")
				pass
	#Player is inside jump attack range
	elif isJumpAttackRange and attackCooldown.is_stopped():
		
		#Is jump attack range but still does ranged attack
		if rand == 0:
			rand = rng.randi_range(0, 1)
			if isRangedRange and attackCooldown.is_stopped():
				if rand == 0:
					fsmManager.change_state(self, "Attack1")
				elif rand == 1:
					fsmManager.change_state(self, "Attack3")
					pass
					
		#Is jump attack and does jump attack
		else:
			if attackCooldown.is_stopped():
					fsmManager.change_state(self, "JumpAttack")
					pass
					
		pass

func Exit():
	pass
