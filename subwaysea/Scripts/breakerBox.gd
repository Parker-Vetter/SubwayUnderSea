extends StaticBody2D


var currentSprite = load("res://assets/oxy_fixed.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var fixedSprite = load("res://assets/oxy_fixed.png")
@onready var brokenSprite = load("res://assets/oxy_broken.png")

@onready var lightParent = self.get_parent().find_child("LightParent")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_parent().connect("wasAttacked", Callable(self, "wasAttacked"))

func wasAttacked(randomValue):
	print(randomValue)
	if randomValue <= 5:
		if currentSprite == fixedSprite:
			lightParent.flickerOff()
		currentSprite = brokenSprite

func repair():
	if currentSprite == brokenSprite:
			lightParent.flickerOn()
	currentSprite = fixedSprite

#set the sprite texture to the variable currentSprite
func changeSprite():
	sprite.texture = currentSprite

#function to change the check the sprite and change the currentSprite variable
func hasSpriteChanged():
	if sprite.texture == fixedSprite:
		currentSprite = brokenSprite
	elif  sprite.texture == brokenSprite:
		currentSprite = fixedSprite
