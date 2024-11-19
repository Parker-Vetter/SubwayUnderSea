extends Node2D

const FACE_1 = preload("res://assets/Face1.png")
const FACE_2 = preload("res://assets/Face2.png")
const FACE_3 = preload("res://assets/Face3.png")

@onready var heartbeat_monitor: AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D
@onready var face_sprite: Sprite2D = $CanvasLayer/Sprite2D
@onready var bpm_display: RichTextLabel = $CanvasLayer/RichTextLabel

var sanity = 0
var old_sanity  = 0
var delta_sanity = 0
var oxygen  = 0
var bpm = 75
var animation_speed = 1

func _process(delta: float) -> void:
	# this all needs to be in one if/elif tree so that the low oxygen face has priority
	if oxygen == "low":
		face_sprite.set_texture(FACE_3)
	elif sanity < 20:
		face_sprite.set_texture(FACE_2)
	elif sanity >= 20:
		face_sprite.set_texture(FACE_1)
	

func alter_heartbeat_speed():
	# delta_sanity falls on a range of -0.2 to 0.2
	delta_sanity = old_sanity - sanity
	animation_speed += delta_sanity
	animation_speed += randf_range(-0.04, 0.04)
	if sanity == 0:
		animation_speed += 0.2
	elif sanity == 70:
		animation_speed -= 0.2
		
	animation_speed = clampf(animation_speed, 1.5, 2.6666)
	heartbeat_monitor.set_speed_scale(animation_speed)

func alter_bpm_display():
	bpm = int(remap(animation_speed, 1.5, 2.6666, 60, 160))
	bpm_display.clear()
	bpm_display.add_text("BPM: " + str(bpm))

func _on_timer_timeout() -> void:
	alter_heartbeat_speed()
	alter_bpm_display()

func _on_sanity_threshold_reached(new_sanity):
	old_sanity = sanity
	sanity = new_sanity

func _on_oxygen_threshold_changed(new_oxygen):
	oxygen = new_oxygen
	
