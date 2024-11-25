extends StaticBody2D


var currentSprite = load("res://assets/Light Machine ON.png")
@onready var depth_gauge: Node2D = $depthGague
@onready var sprite: Sprite2D = $Sprite2D
@onready var blinkingSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fixedSprite = load("res://assets/Engine ON.png")
@onready var brokenSprite = load("res://assets/Engine OFF.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blinkingSprite.visible = true
	depth_gauge.delta_depth = 0
	self.get_parent().connect("wasAttacked", Callable(self, "wasAttacked"))
	print(self.get_parent().name)

func wasAttacked(randomValue):
	if randomValue <= 10:
		currentSprite = brokenSprite
		#$WorkingAudio.stop()
		depth_gauge.delta_depth = 0

func repair():
	currentSprite = fixedSprite
	depth_gauge.delta_depth = 1

#set the sprite texture to the variable currentSprite
func changeSprite():
	sprite.texture = currentSprite
	if currentSprite == brokenSprite:
		blinkingSprite.visible = true
	else:
		blinkingSprite.visible = false

#function to change the check the sprite and change the currentSprite variable
func hasSpriteChanged():
	if sprite.texture == fixedSprite:
		currentSprite = brokenSprite
	elif  sprite.texture == brokenSprite:
		currentSprite = fixedSprite

func _process(delta: float) -> void:
	if currentSprite == fixedSprite and $WorkingAudio.playing == false:
		$WorkingAudio.play()
