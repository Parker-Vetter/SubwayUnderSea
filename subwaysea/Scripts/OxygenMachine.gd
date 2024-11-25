extends Node2D

var insideArea = false
var multiplier = 1
var oxygenAmount = 50
var oxygenCap = 100

var currentSprite = load("res://assets/oxy_fixed.png")

@onready var face_display: Node2D = $"../FaceDisplay"
@onready var playerOxyTank = get_parent().find_child("PlayerOxyTank").get_child(0)
@onready var player = get_tree().get_first_node_in_group('player')
@onready var sprite: Sprite2D = $Sprite2D
@onready var fixedSprite = load("res://assets/oxy_fixed.png")
@onready var brokenSprite = load("res://assets/oxy_broken.png")
@onready var blinkingSprite: AnimatedSprite2D = $AnimatedSprite2D

signal oxygen_threshold_changed(oxygen_threshold)

func _ready() -> void:
	$Rope/Anchor.global_position = global_position
	$Rope/End.global_position = global_position
	blinkingSprite.visible = false
	self.get_parent().connect("wasAttacked", Callable(self, "wasAttacked"))
	self.connect("oxygen_threshold_changed", face_display._on_oxygen_threshold_changed)

# randomValue can be between 0 and 10 so if we hit 5 through 10 oxygen will break
func wasAttacked(randomValue):
	if randomValue >= 5:
		currentSprite = brokenSprite
		$WorkingAudio.stop()
		$light.energy = 0

# set the oxygen meter to go up again
func repair():
	if currentSprite == brokenSprite:
		currentSprite = fixedSprite
		$light.energy = 3
		$Fixed.play()
		return true
func _process(delta: float) -> void:
	playerOxyTank.set("value", oxygenAmount)
	determine_oxygen_threshold()
	if currentSprite == fixedSprite and $WorkingAudio.playing == false:
		$WorkingAudio.play()
	
	if insideArea:
		if oxyplay.playing == false:
			oxyplay.play()
		elif oxyplay.get_playback_position() >= 6 and oxyplay_2.playing == false:
			oxyplay_2.play()
		oxyplay.bus = 'Master'


@onready var oxyplay: AudioStreamPlayer = $oxyplay
@onready var oxyplay_2: AudioStreamPlayer = $oxyplay2

func addOxygen():
	if (oxygenAmount < oxygenCap) and (sprite.texture == fixedSprite):
		oxygenAmount += 1.5
		$Rope/Anchor.global_position = global_position
		$Rope/End.global_position = lerp($Rope/End.global_position, player.global_position - Vector2(0,40), .5)

		

func loseOxygen():
	oxygenAmount = max(0, oxygenAmount - (1 * multiplier))
	


func determine_oxygen_threshold():
	var oxygen_threshold

	if oxygenAmount == 0:
		get_parent().dying = true
	elif oxygenAmount < 25:
		get_parent().dying = false
		oxygen_threshold = "low"
	else:
		oxygen_threshold = "high"
	oxygen_threshold_changed.emit(oxygen_threshold)

func _on_fill_up_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		insideArea = true

func _on_fill_up_area_body_exited(body: Node2D) -> void:
	insideArea = false
	oxyplay.stop()
	oxyplay_2.stop()

func _on_up_timeout() -> void:
	if insideArea:
		addOxygen()
	else:
		$Rope/End.global_position = lerp($Rope/End.global_position, global_position, .5)

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
