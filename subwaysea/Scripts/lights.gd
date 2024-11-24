extends Node2D

@onready var mainscene: Node2D = $".."
@onready var sanity = $"../SanitySystem"
@onready var onLight = load("res://assets/light_on.png")
@onready var offLight = load("res://assets/light_off.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child in get_children():
		if child.energy == 0:
			child.find_child("Sprite2D").set_texture(offLight)
		else:
			child.find_child("Sprite2D").set_texture(onLight)

func flickerOn():
	var randint = randi_range(15,25) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		child.energy = 6 #sets the light back to normal brightness
	sanity.disable_debuff_area() #disable the sanity debuff area

func flickerOff():
	var randint = randi_range(25,35) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		child.energy = 0 #turns the lights off
	sanity.enable_debuff_area() #reenable the sanity debuff area

func awaitTimer():
	if get_tree().current_scene == mainscene:
		for child in get_children():
			var rand = randi_range(0,6) #choses an int between 0 and max energy
			child.energy = rand #sets brightness to the random int
		await get_tree().create_timer(0.05).timeout #creates a timer for the flicker to last for
