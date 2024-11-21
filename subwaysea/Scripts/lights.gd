extends Node2D

func flickerOn():
	var randint = randi_range(15,25) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		child.energy = 6 #sets the light back to normal brightness	

func flickerOff():
	var randint = randi_range(15,25) #gets a random integer between two numbers
	for i in range(randint): #flickers a randint number of times
		await awaitTimer() #wait for the timer to finish
	for child in get_children():
		child.energy = 0 #sets the light back to normal brightness	

func awaitTimer():
	for child in get_children():
		var rand = randi_range(0,6) #choses an int between 0 and max energy
		child.energy = rand #sets brightness to the random int
	await get_tree().create_timer(0.05).timeout #creates a timer for the flicker to last for
