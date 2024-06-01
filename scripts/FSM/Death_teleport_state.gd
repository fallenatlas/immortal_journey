extends State
class_name DeathTeleportState

@onready var fsmManager = $".."
@onready var body = $"../.."
@onready var anim = $"../../AnimationPlayer"

var rng = RandomNumberGenerator.new()

func Enter():
	anim.play("Teleport")
	
func Update(delta: float):
	if not anim.is_playing():
		fsmManager.change_state(self, "Idle")

func Exit():
	pass

func teleport_position():
	var rand = rng.randi_range(0, 5)
	
	match rand:
		0:
			body.position = body.teleportPos1.position
		1:
			body.position = body.teleportPos2.position
		2:
			body.position = body.teleportPos3.position
		3:
			body.position = body.teleportPos4.position
		4:
			body.position = body.teleportPos5.position
		_:
			pass

