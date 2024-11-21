extends Node

const COMPONENT = preload("res://Scenes/component.tscn")

func debrisCollected():
	var newComponent = COMPONENT.instantiate()
	get_parent().add_child(newComponent)
	newComponent.global_position = self.global_position

#debris_collected signal from debris.gd
func _on_debris_container_child_entered_tree(node: Node) -> void:
	if node.name == "debris":
		node.connect("debris_collected", Callable(self, "debrisCollected"))
	else:
		pass


func _on_debris_container_child_exiting_tree(node: Node) -> void:
	pass # Replace with function body.
