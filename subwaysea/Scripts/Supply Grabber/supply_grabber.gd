extends Node2D

const DEBRIS = preload("res://Scenes/Supply Grabber/debris.tscn")
@onready var sonar: PointLight2D = $sonar
@onready var debris_container = get_node("DebrisContainer")
@onready var absolutyStop = $AbsolutlyStop

signal tick
var alpha = 1
var currently_collecting = false
var collecting_flash = 0.0

func _ready():
	# Ensure a random seed for randomness
	randomize()

func check_for_debris_spawn():
	var randint = randi_range(0, 4)
	# variable probability to spawn depending on current existing debris
	if randint < (4 - debris_container.get_child_count()):
		create_new_debris()

func create_new_debris():
	var instance = DEBRIS.instantiate()
	if not instance.has_method("_on_tick"):
		print("Error: Instance does not have _on_tick method. in supply_grabber.gd")
		return
	self.connect("tick", instance._on_tick)
	debris_container.add_child(instance)

func modify_sonar():
	# cycle sonar texture scale
	if sonar.texture_scale < 1:
		sonar.texture_scale += 0.2
	else:
		sonar.texture_scale = 0.2

func _on_timer_timeout() -> void:
	tick.emit()
	check_for_debris_spawn()
	modify_sonar()

func _process(delta: float) -> void:
	# Handle the "collecting" state
	if currently_collecting:
		update_collecting_visuals(delta)
		if absolutyStop.is_stopped():
			absolutyStop.set_wait_time(6.0)
			absolutyStop.start()
	else:
		reset_collecting_visuals()

func update_collecting_visuals(delta: float) -> void:
	$CurrentlyCollectingText.show()
	$CoverScreen.show()
	collecting_flash += delta
	# Flash effect
	if collecting_flash >= 1:
		collecting_flash = 0
		$CurrentlyCollectingText.modulate = Color("ca8b38")
	elif collecting_flash >= 0.5:
		$CurrentlyCollectingText.modulate = Color("221303")

func reset_collecting_visuals() -> void:
	$CurrentlyCollectingText.hide()
	$CoverScreen.hide()
	$CurrentlyCollectingText.modulate = Color("ca8b38")
	currently_collecting = false
	absolutyStop.stop()

# Debugging and additional reset logic
func stop_collecting():
	currently_collecting = false
	reset_collecting_visuals()
