extends AudioStreamPlayer

@onready var amb_new = preload("res://Scenes/ambience.tscn")
var spawned = false

func _process(delta: float) -> void:
	if get_playback_position() >= 26.0 and !spawned:
		spawned = true
		var new = amb_new.instantiate()
		self.add_child(new)
