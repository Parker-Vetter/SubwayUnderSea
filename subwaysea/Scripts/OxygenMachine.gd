extends Node

var insideArea = false
var Multilpier = 1
var oxygenAmount = 100
var oxygenCap = 100

func addOxygen():
	if oxygenAmount < oxygenCap:
		oxygenAmount = oxygenAmount + (1 * Multilpier)

func loseOxygen():
	oxygenAmount -= 1

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
