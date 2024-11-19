extends Node

const COMPONENT = preload("res://Scenes/component.tscn")

func debrisCollected():
	print("Called")
	var newComponent = COMPONENT.instantiate()
	get_parent().add_child(newComponent)
	newComponent.global_position = self.global_position

func _on_debris_container_child_entered_tree(node: Node) -> void:
	if node.name == "debris":
		node.connect("debris_collected", Callable(self, "debrisCollected"))


func _on_debris_container_child_exiting_tree(node: Node) -> void:
	pass # Replace with function body.
