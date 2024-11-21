extends Camera2D

var decay := .8 #How quickly shaking will stop [0,1].
var max_offset := Vector2(480*.01,272*.01) #this reduces how much your camera can shake
var max_roll = 0.01 #Maximum rotation in radians (use sparingly).
@onready var noise = preload("res://assets/cam_noise.tres")
@onready var player = get_tree().get_first_node_in_group('player')
@onready var mainScene = get_tree().root.get_node("MainScene")

var noise_y = 0 #Value used to move through the noise
var trauma := 0.0 #Current shake strength
var trauma_pwr := 2 #Trauma exponent. Use [2,3]

var tension = 2 #this simulates the camera going back to its orignal position like an elastic spring
var damp = .1 #this changes how fast your camera resets to its original state
const target_pos = Vector2.ZERO # where to reset your position back to, its a variable that never changes
var shake_pos = Vector2.ZERO #this gets changed to simulate an offset 
var velocity = Vector2.ZERO #changes how fast your offset changes

func _ready():
	ignore_rotation = false
	mainScene.connect("wasAttacked", Callable(self, "attacked"))
	if player != null: position = player.position
#black out area you were just in thats part of the gameplay
func transition(point : Vector2): #ig just position
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, 'position', point + Vector2(160, 90), .5)

func _process(delta):
	player = get_tree().get_first_node_in_group('player')
	if trauma: 
		trauma = max(trauma - decay * delta, 0)
		shake()
	var displacement = (target_pos - shake_pos) * delta    #distance to center
	velocity += (displacement * tension) - (velocity * damp)
	shake_pos += velocity
	if player != null: position.x = player.position.x
	offset = shake_pos #this is the property that moves the camera

func attacked(randValue):
	print("attacked Called")
	add_trauma(1, Vector2.RIGHT)


func add_trauma(amount : float, direction : Vector2): #this function starts everything
	trauma = min(trauma + amount, 1.0) #for the regular camera shake motion
	velocity += direction #for the spring camera motion
	#noise.seed = randi()

func shake(): #you can kinda ignore this
	var amt = pow(trauma, trauma_pwr)
	#print(noise.get_noise_2d(noise.seed*2,noise_y))
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(noise.seed,noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(noise.seed*2,noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(noise.seed*3,noise_y)

func freeze_frame(time : float, speed : float):
	Engine.time_scale = speed
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1

func change_y(y_to_change):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, 'position:y', y_to_change, 1)
