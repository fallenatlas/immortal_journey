extends State
class_name PlayerJumpAttack

@export var SPEED = 300

@onready var sprite = $"../../Sprite2D"
@onready var body = $"../.."

var isFlipped
var isJumping = false

func Enter():
	anim.play("JumpAttack")
	attackCooldown.start()
	isFlipped = sprite.flip_h
	
func Update(delta: float):
	if isJumping:
		if isFlipped:
			body.position.x += - SPEED * delta
		else:
			body.position.x += SPEED * delta

func Exit():
	body.velocity.x = 0


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "JumpAttack":
		fsmManager.change_state(self, "Idle")

func enableIsJumping():
	isJumping = true
	
func disableIsJumping():
	isJumping = false
