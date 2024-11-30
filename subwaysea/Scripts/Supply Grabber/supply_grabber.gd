extends Node2D

const DEBRIS = preload("res://Scenes/Supply Grabber/debris.tscn")
@onready var sonar: PointLight2D = $sonar
@onready var debris_container = get_node("DebrisContainer")

signal tick
var alpha = 1
var currently_collecting = false

func check_for_debris_spawn():
	var randint = randi_range(0, 4)
	# variable probability to spawn depending on current existing debris
	if randint < (4 - debris_container.get_child_count()):
		create_new_debris()

func create_new_debris():
	var instance = DEBRIS.instantiate()
	self.connect("tick", instance._on_tick)
	find_child("DebrisContainer").add_child(instance)

func modify_sonar():
	if sonar.texture_scale < 1:
		sonar.texture_scale += 0.2
	else:
		sonar.texture_scale = 0.2

func _on_timer_timeout() -> void:
	tick.emit()
	check_for_debris_spawn()
	modify_sonar()

var collecting_flash = 0
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("blah"): 
		#currently_collecting = false
	
	if currently_collecting:
		$CurrentlyCollectingText.show()
		$CoverScreen.show()
		collecting_flash += delta
		if collecting_flash >= 1:
			collecting_flash = 0
			$CurrentlyCollectingText.modulate = Color('ca8b38')
		elif collecting_flash >= .5: 
			$CurrentlyCollectingText.modulate = Color('221303')
	else:
		$CurrentlyCollectingText.hide()
		$CoverScreen.hide()
		$CurrentlyCollectingText.modulate = Color('ca8b38')
		currently_collecting = false
