extends Node2D

@onready var oxygen_system: Node2D = $"../OxygenSystem"
@onready var face_display: Node2D = $"../FaceDisplay"
@onready var breathing: AudioStreamPlayer = $Breathing
@onready var heart_beat: AudioStreamPlayer = $HeartBeat

signal oxygen_multiplier_changed(new_multiplier)
signal sanity_threshold_reached(threshold)

var in_buff_area
var in_debuff_area
var sanity = 70
var sanity_effect = 0.0
func _ready() -> void:
	self.connect("sanity_threshold_reached", face_display._on_sanity_threshold_reached)

var delta_heart = 0
func _process(delta: float) -> void:
	passive_sanity_loss(delta)
	
	if in_buff_area:
		add_sanity(delta)
	if in_debuff_area:
		remove_sanity(delta)
	
	sanity = clamp(sanity, 0, 70)
	#var sanity_effect = (1/(sanity/69) - 1) * .01
	
	if get_parent().dying:
		breathing.pitch_scale = lerp(breathing.pitch_scale, 1.3, delta )
		breathing.volume_db = lerp(breathing.volume_db, -5.0, delta)
	elif sanity <= 10:
		sanity_effect = lerp(sanity_effect, .01, delta)
		breathing.pitch_scale = lerp(breathing.pitch_scale, 1.2, delta * .1)
		breathing.volume_db = lerp(breathing.volume_db, -10.0, delta)
	elif sanity <= 30:
		sanity_effect = lerp(sanity_effect, .005, delta)
		breathing.pitch_scale = lerp(breathing.pitch_scale, 1.1, delta * .1)
		breathing.volume_db = lerp(breathing.volume_db, -20.0, delta)
	elif sanity <= 50:
		sanity_effect = lerp(sanity_effect, .001, delta)
		breathing.pitch_scale = 1.0
		breathing.volume_db = -25
	else:
		sanity_effect = lerp(sanity_effect, 0.0, delta)
		breathing.volume_db = -30
	
	#print(1 - sanity/70)
	#delta_heart += delta
	#print(sin(delta_heart))
	#if sin(delta_heart) >= .8:
		#pass
	$CanvasLayer/Sprite2D.material.set_shader_parameter('distortion_strength', sanity_effect)
	calculate_multiplier()
	determine_sanity_threshold()

#tweak all of these values for to balance sanity
func add_sanity(delta):
	sanity += 2 * delta

func remove_sanity(delta):
	sanity -= 5 * delta

func passive_sanity_loss(delta):
	sanity -= 0.8 * delta

func calculate_multiplier():
		var multiplier = 1 - sanity/70
		multiplier = clamp(multiplier, 0.1, 1)
		oxygen_multiplier_changed.emit(multiplier)

func determine_sanity_threshold():
	#none of this is needed for some reason, Why?
	#var sanity_threshold
	#if sanity < 45:
		#sanity_threshold = "low"
	#else:
		#sanity_threshold = "high"
	sanity_threshold_reached.emit(sanity)

func _on_sanity_debuff_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_debuff_area = true


func _on_sanity_debuff_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_debuff_area = false


func _on_sanity_buff_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_buff_area = true


func _on_sanity_buff_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_buff_area = false


func _on_cat_photo_sanity_changed(new_sanity: Variant, delta) -> void:
	sanity += 0.3 * new_sanity * delta
	
func disable_debuff_area():
	find_child("Sanity Debuff Area").monitoring = false

func enable_debuff_area():
	find_child("Sanity Debuff Area").monitoring = true
