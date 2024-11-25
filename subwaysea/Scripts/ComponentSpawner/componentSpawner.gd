extends Node

const COMPONENT = preload("res://Scenes/component.tscn")
@onready var mainSceneCall = self.get_parent()

# connected signal from instantiated debris
func debrisCollected():
	var newComponent = COMPONENT.instantiate()
	get_parent().add_child(newComponent)
	newComponent.apply_torque_impulse(10)
	$AudioStreamPlayer2D.play()
	newComponent.global_position = self.global_position
	await get_tree().create_timer(.3).timeout
	$CPUParticles2D.emitting = true
