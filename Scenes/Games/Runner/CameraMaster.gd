extends Camera2D
#ScreenShake adapted from KidsCanCode tutorial

var runner_offset = 196

@export var target : NodePath #The node the camera will follow
@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()
	#Limit setters
	#Default limits for standard platformer
	#limit_top = 0
	limit_left = 0

func intro():
	position.y = -254
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 180, 2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	if Global.show_title_screen:
		tween.chain().tween_callback(get_parent().show_titlescreen)

func add_screen_shake(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
#	offset.y = max_offset.y * amount * randf_range(-1, 1)

func center():
	#Centers the camera if there is an offset value
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "offset:x", 0, 1.0).set_ease(Tween.EASE_OUT)
#	tween.tween_property(self, "offset:y", 0, 1.0).set_ease(Tween.EASE_OUT)

func decenter():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "offset:x", runner_offset, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _process(delta):
	if target == null:
		return
	var player = get_node_or_null(target)
	if is_instance_valid(player):
		self.global_position.x = player.global_position.x
		if trauma:
			trauma = max(trauma - decay * delta, 0)
			shake()
