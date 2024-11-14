extends Node2D

const Director = preload("res://Scripts/director.gd")

var mouse_hover = false

signal debris_collected()

@onready var is_monster = randi_range(0, 1)

func _ready() -> void:
	self.connect("debris_collected", Director._on_debris_collected)
	if is_monster:
		position.x = randfn(0, 64)
		position.y = 100
	else:
		position.x = randfn(0, 64)
		position.y = -100

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse") and mouse_hover:
		debris_collected.emit()
		self.queue_free()
	

func check_position():
	if position.x > 255 or position.x < -255:
		self.queue_free()
	if position.y > 100 or position.y < -100:
		self.queue_free()

func move_debris():
	if is_monster:
		position.x += randi_range(-5, 5)
		position.y -= randfn(10, 5)
	else:
		position.y += 5


func _on_area_2d_mouse_entered() -> void:
	mouse_hover = true


func _on_area_2d_mouse_exited() -> void:
	mouse_hover = true


func _on_tick():
	move_debris()
	check_position()
