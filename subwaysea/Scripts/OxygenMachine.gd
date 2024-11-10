extends Node

var insideArea = false
var multiplier = 1
var oxygenAmount = 100
var oxygenCap = 100

func addOxygen():
	if oxygenAmount < oxygenCap:
		oxygenAmount = oxygenAmount
	print(oxygenAmount)
	
func loseOxygen():
	oxygenAmount -= 1 * multiplier
	print(oxygenAmount)

func _on_fill_up_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		insideArea = true


func _on_fill_up_area_body_exited(body: Node2D) -> void:
	insideArea = false


func _on_up_timeout() -> void:
	if insideArea:
		addOxygen()

func _on_down_timeout() -> void:
	if !insideArea:
		loseOxygen()


func _on_sanity_resource_oxygen_multiplier_changed(new_multiplier: Variant) -> void:
	multiplier = new_multiplier
