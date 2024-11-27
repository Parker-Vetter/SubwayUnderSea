extends Node

signal wasAttacked
signal MainInitialized

@onready var run_timer: Timer = find_child("RunTimer")
@onready var randomAttackTimer = find_child("AttackTimer")
@onready var fadeIn: ColorRect = $ColorRect

var dying := false
var depth := 600
var run_time := 0

func _process(delta: float) -> void:
	if dying and fadeIn.color.a < 1.0:
		fadeIn.color.a += 0.15 * delta
	elif fadeIn.color.a >= 1.0:
		dying = false
		get_tree().reload_current_scene()
	if dying == false:
		fadeIn.color.a = max(0, fadeIn.color.a - delta,0)
	#
	#if Input.is_action_just_pressed('interact'):
		#callForAttack()

func _ready() -> void:
	var depth_multiplier = remap(run_time, 0, 400, 1, 0)
	var wait_time = int(randfn(30 + 60 * depth_multiplier, 10))
	randomAttackTimer.wait_time = wait_time
	randomAttackTimer.autostart = true
	MainInitialized.emit()


# function needs to be called when the monster or anything else triggers an attack event
# called on instantiated debris click event
func callForAttack():
	emitWasAttacked()

#emit signal to all machines that their was an attack
func emitWasAttacked(): #HULL can access as soon as its attacked
	$BLAST.play()
	await get_tree().create_timer(.95).timeout
	var randValue = randi_range(0,10)
	wasAttacked.emit(randValue)
	# connect to OxygenMachine.gd and breakerBox.gd and camera.gd

# call attack on end of timer then reset the time to be somethign else
func _on_attack_timer_timeout() -> void:
	callForAttack()
	var depth_multiplier = remap(run_time, 0, 500, 1, 0)
	var wait_time = int(randfn(20 + 20 * depth_multiplier, 10))
	randomAttackTimer.wait_time = wait_time

func depth_change_call(new_depth):
	depth = new_depth


func _on_run_timer_timeout() -> void:
	run_time += 1
