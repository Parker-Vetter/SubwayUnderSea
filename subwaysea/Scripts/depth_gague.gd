extends Node2D

@onready var label: Label = $Label
@export var depth: int
@export var delta_depth: int
@onready var fadeIn: ColorRect = $ColorRect
@onready var surfacing_label: Label = $"CanvasLayer/surfacing label"
@onready var main_scene = self.get_tree().root.get_node("MainScene")
var dots = ""
var alpha = 0

# connects to attack handler for variable monster attacks
signal emit_depth(depth)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("emit_depth", main_scene.depth_change_call)
	delta_depth = 1
	updateGauge()
	surfacing_label.visible = false

func _process(delta: float) -> void:
	if depth < 12 and fadeIn.color.a < 1.0:
		fadeIn.color.a += 0.1 * delta

func updateGauge():
	label.set_text("Depth: " + str(depth) + "m") #chagee the text to depth with m for meters
	await awaitTimer() #wait for await

func awaitTimer():
	if depth > 0: #if depth is not 0, then decrease it by 1
		depth -= delta_depth
		await get_tree().create_timer(1).timeout #create a timer and wait until it finishes
		updateGauge() #run this loop again
		emit_depth.emit(depth)
		if depth <= 10:
			alterGoofySurfacingText()
	else:
		get_tree().change_scene_to_file("res://Scenes/WinMenu/WinScene.tscn") #when depth reaches 0 (surface), then return to main menu

func alterGoofySurfacingText():
	# dude this code is the stupidest thing i have ever written
	surfacing_label.visible = true
	if dots != "...":
		dots += "."
	else:
		dots = ""
	surfacing_label.set_text("SURFACING" + dots)
