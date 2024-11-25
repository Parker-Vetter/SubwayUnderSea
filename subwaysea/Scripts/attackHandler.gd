extends Node

signal wasAttacked
signal MainInitialized

@onready var randomAttackTimer = find_child("AttackTimer")
@onready var fadeIn: ColorRect = $ColorRect
var dying = false

func _process(delta: float) -> void:
	if dying and fadeIn.color.a < 1.0:
		fadeIn.color.a += 0.15 * delta
		print(fadeIn.color.a)
	elif fadeIn.color.a >= 1.0:
		dying = false
		get_tree().reload_current_scene()
	if dying == false:
		fadeIn.color.a = max(0, fadeIn.color.a - delta,0)
	#
	if Input.is_action_just_pressed('interact'):
		#callForAttack()
		pass

func _ready() -> void:
	Engine.time_scale = 1
	randomAttackTimer.wait_time = randi_range(60,300)
	randomAttackTimer.autostart = true
	MainInitialized.emit()

# function needs to be called when the monster or anything else triggers an attack event
# called on instantiated debris click event
func callForAttack():
	emitWasAttacked()

#emit signal to all machines that their was an attack
func emitWasAttacked():
	
	var randValue = randi_range(0,10)
	wasAttacked.emit(randValue)
	# connect to OxygenMachine.gd and breakerBox.gd and camera.gd

# call attack on end of timer then reset the time to be somethign else
func _on_attack_timer_timeout() -> void:
	callForAttack()
	randomAttackTimer.wait_time = randi_range(120,300)
