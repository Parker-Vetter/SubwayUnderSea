extends Node

signal wasAttacked

@onready var randomAttackTimer = %AttackTimer

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	randomAttackTimer.autostart = true
	randomAttackTimer.wait_time = randi_range(120,600)

# function needs to be called when the monster or anything else triggers an attack event
# currently this is not implemented anywhere
func callForAttack():
	emitWasAttacked()

#emit signal to all machines that their was an attack
func emitWasAttacked():
	var randValue = randi_range(0,10)
	wasAttacked.emit(randValue)
	# connect to OxygenMachine.gd and breakerBox.gd

# call attack on end of timer then reset the time to be somethign else
func _on_attack_timer_timeout() -> void:
	callForAttack()
	randomAttackTimer.wait_time = randi_range(120,600)
