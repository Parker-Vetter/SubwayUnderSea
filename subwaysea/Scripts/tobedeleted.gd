extends Area2D

@onready var rect: ColorRect = $DELETEME
@onready var c = "BLUE"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		changeColor()

func changeColor():
	if c == "BLUE":
		c = "RED"
	elif c == "RED":
		c = "BLUE"
		
func setColor():
	rect.color=c
