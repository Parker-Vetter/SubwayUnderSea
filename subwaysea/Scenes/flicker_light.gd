extends PointLight2D

@onready var maxEnergy = self.energy #sets the maxEnergy to whatever the energy was on startup

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"): #press 'w' to test the flicker
		flicker()

func flicker():
	var randint = randi_range(15,25) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	self.energy = maxEnergy #sets the light back to normal brightness

func awaitTimer():
	var rand = randi_range(0,6) #choses an int between 0 and max energy
	self.energy = rand #sets brightness to the random int
	await get_tree().create_timer(0.05).timeout #creates a timer for the flicker to last for
