extends Node

var insideArea = false
var multiplier = 1
var oxygenAmount = 100
var oxygenCap = 100

@onready var playerOxyTank = get_parent().find_child("PlayerOxyTank").get_child(0)

func _process(delta: float) -> void:
	playerOxyTank.set("value", oxygenAmount)

func addOxygen():
	if oxygenAmount < oxygenCap:
		oxygenAmount += 1

func loseOxygen():
	oxygenAmount -= 1 * multiplier

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


func _on_sanity_system_oxygen_multiplier_changed(new_multiplier: Variant) -> void:
	multiplier = new_multiplier
