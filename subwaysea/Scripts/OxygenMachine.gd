extends Node

var insideArea = false
var multiplier = 1
var oxygenAmount = 70
var oxygenCap = 100

var currentSprite = load("res://assets/oxy_fixed.png")

@onready var face_display: Node2D = $"../FaceDisplay"
@onready var playerOxyTank = get_parent().find_child("PlayerOxyTank").get_child(0)
@onready var sprite: Sprite2D = $Sprite2D
@onready var fixedSprite = load("res://assets/oxy_fixed.png")
@onready var brokenSprite = load("res://assets/oxy_broken.png")
@onready var blinkingSprite: AnimatedSprite2D = $AnimatedSprite2D

signal oxygen_threshold_changed(oxygen_threshold)
signal death

func _ready() -> void:
	blinkingSprite.visible = false
	self.connect("death", self.get_parent().death)
	self.get_parent().connect("wasAttacked", Callable(self, "wasAttacked"))
	self.connect("oxygen_threshold_changed", face_display._on_oxygen_threshold_changed)

# randomValue can be between 0 and 10 so if we hit 5 through 10 oxygen will break
func wasAttacked(randomValue):
	if randomValue >= 5:
		currentSprite = brokenSprite
		$WorkingAudio.stop()

# set the oxygen meter to go up again
func repair():
	currentSprite = fixedSprite

func _process(delta: float) -> void:
	playerOxyTank.set("value", oxygenAmount)
	determine_oxygen_threshold()
	if currentSprite == fixedSprite and $WorkingAudio.playing == false:
		$WorkingAudio.play()

func addOxygen():
	if (oxygenAmount < oxygenCap) and (sprite.texture == fixedSprite):
		oxygenAmount += 2

func loseOxygen():
	oxygenAmount -= 1 * multiplier
	if oxygenAmount <= 0:
		death.emit()

func determine_oxygen_threshold():
	var oxygen_threshold
	if oxygenAmount == 0:
		get_parent().death()
	elif oxygenAmount < 50:
		oxygen_threshold = "low"
	else:
		oxygen_threshold = "high"
	oxygen_threshold_changed.emit(oxygen_threshold)

func _on_fill_up_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		insideArea = true

func _on_fill_up_area_body_exited(body: Node2D) -> void:
	insideArea = false

func _on_up_timeout() -> void:
	if insideArea:
		addOxygen()

func _on_down_timeout() -> void:
	if !insideArea || sprite.texture == brokenSprite:
		loseOxygen()

func _on_sanity_system_oxygen_multiplier_changed(new_multiplier: Variant) -> void:
	multiplier = new_multiplier

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
