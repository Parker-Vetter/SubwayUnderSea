extends CollisionPolygon2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cpu_particles_2d.emission_points = polygon

func play():
	cpu_particles_2d.emitting = true
