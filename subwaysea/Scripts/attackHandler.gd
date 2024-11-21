extends Node

signal wasAttacked

func _process(delta: float) -> void:
	#pass
	if Input.is_action_just_pressed('interact'):
		callForAttack()

# function needs to be called when the monster or anything else triggers an attack event
# currently this is not implemented anywhere
func callForAttack():
	emitWasAttacked()

#emit signal to all machines that their was an attack
func emitWasAttacked():
	var randValue = randi_range(0,10)
	print(randValue)
	wasAttacked.emit(randValue)
	# connect to OxygenMachine.gd and breakerBox.gd
