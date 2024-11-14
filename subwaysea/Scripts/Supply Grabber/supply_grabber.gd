extends Node2D

const DEBRIS = preload("res://Scenes/Supply Grabber/debris.tscn")
@onready var sonar: PointLight2D = $sonar

signal tick
var alpha = 1

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func check_for_debris_spawn():
	var randint = randi_range(0, 4)
	if randint == 0:
		create_new_debris()

func create_new_debris():
	var instance = DEBRIS.instantiate()
	self.connect("tick", instance._on_tick)
	add_child(instance)
	
func modify_sonar():
	if sonar.texture_scale < 1:
		sonar.texture_scale += 0.2
	else:
		sonar.texture_scale = 0.2
	
	if alpha > 0:
		alpha -= 0.25
	else:
		alpha = 1
	sonar.set_energy(alpha)

func _on_timer_timeout() -> void:
	tick.emit()
	check_for_debris_spawn()
	modify_sonar()
	
