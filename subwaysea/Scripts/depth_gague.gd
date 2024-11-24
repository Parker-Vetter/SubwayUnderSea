extends Node2D

@onready var label: Label = $Label
@export var depth: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateGauge()


func updateGauge():
	label.set_text(str(depth) + "m") #chagee the text to depth with m for meters
	await awaitTimer() #wait for await

func awaitTimer():
	if depth > 0: #if depth is not 0, then decrease it by 1
		depth -= 1
		await get_tree().create_timer(1).timeout #create a timer and wait until it finishes
		updateGauge() #run this loop again
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") #when depth reaches 0 (surface), then return to main menu
