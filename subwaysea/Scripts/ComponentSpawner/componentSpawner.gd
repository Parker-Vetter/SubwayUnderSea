extends Node

const COMPONENT = preload("res://Scenes/component.tscn")
@onready var mainSceneCall = self.get_parent()

# connected signal from instantiated debris
func debrisCollected():
	var newComponent = COMPONENT.instantiate()
	get_parent().add_child(newComponent)
	newComponent.global_position = self.global_position
