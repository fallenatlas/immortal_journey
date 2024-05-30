class_name TutorialPopups
extends CanvasLayer

enum MECHANIC {MOVE, HEALTH, DASH, ATTACK, COURAGE, INTERACT}

@onready var move_popup : Control = get_node("Move")
@onready var health_popup : Control = get_node("Health")
@onready var dash_popup : Control = get_node("Dash")
@onready var attack_popup : Control = get_node("Attack")
@onready var courage_popup : Control = get_node("Courage")
@onready var interact_popup : Control = get_node("Interact")

func trigger(popup : MECHANIC) -> void:
	disable_all()
	match popup:
		MECHANIC.MOVE:
			move_popup.visible = true
		MECHANIC.HEALTH:
			health_popup.visible = true
		MECHANIC.DASH:
			dash_popup.visible = true
		MECHANIC.ATTACK:
			attack_popup.visible = true
		MECHANIC.COURAGE:
			courage_popup.visible = true
		MECHANIC.INTERACT:
			interact_popup.visible = true
		_:
			pass

func disable_all():
	move_popup.visible = false
	health_popup.visible = false
	dash_popup.visible = false
	attack_popup.visible = false
	courage_popup.visible = false
	interact_popup.visible = false
