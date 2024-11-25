extends Node2D

const Director = preload("res://Scripts/director.gd")
@onready var main_scene =  get_node("/root/MainScene")
@onready var componentSpawner =  get_node("/root/MainScene/ComponentSpawner")
var mouse_hover = false

signal debris_collected

@onready var is_monster = randi_range(0, 1)

var monster_is_on_left

func _ready() -> void:
	if is_monster:
		# connects directly to attack handler to call for attack
		self.connect("debris_collected", main_scene.callForAttack)
		initialize_monster_position()
	else:
		# connects to component spawner to call for new component
		self.connect("debris_collected", componentSpawner.debrisCollected)
		position.x = randfn(0, 64)
		position.y = -100

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse") and mouse_hover:
		debris_collected.emit()
		self.queue_free()
	
## MONSTER-RELATED FUNCTIONS
func initialize_monster_position():
	monster_is_on_left = randi_range(0, 1)
	if monster_is_on_left:
		position.x = -192
	else:
		position.x = 192
	position.y = randfn(0, 32)

func monster_movement():
	if monster_is_on_left:
		position.x += randfn(10, 5)
	else:
		position.x -= randfn(10, 5)
	position.y -= randi_range(-5, 5)

func move_object():
	if is_monster:
		monster_movement()
	else:
		position.y += 5

func check_position():
	if position.x > 255 or position.x < -255:
		self.queue_free()
	if position.y > 100 or position.y < -100:
		self.queue_free()

func _on_tick():
	move_object()
	check_position()

func _on_area_2d_mouse_entered() -> void:
	mouse_hover = true


func _on_area_2d_mouse_exited() -> void:
	mouse_hover = true
