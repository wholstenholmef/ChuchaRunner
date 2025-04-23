extends CharacterBody2D

const gravity = 9.8
@export var jump_power = -340
@export var speed = 100
var direction = Vector2.ZERO
var score_counter = 0
var collectible_combo = 1

var mainCamera

var state
enum MACHINE { 
	RUN,
	JUMP, 
	SPIN, 
	LANDING,
	DEAD,
}

func _ready():
	mainCamera = get_viewport().get_camera_2d()
	state = MACHINE.RUN
	direction = Vector2.RIGHT

func get_hud():
	return HUD

func _physics_process(delta):
	velocity.x = direction.x * speed
	velocity.y += gravity
	match state:
		MACHINE.RUN:
			$AnimatedSprite2D.play("run")
			if Input.is_action_just_pressed("jump"):
				state = MACHINE.JUMP
				jump()
			if !is_on_floor():
				state = MACHINE.JUMP
		MACHINE.JUMP:
			if $AnimatedSprite2D.animation != "jump":
				$AnimatedSprite2D.play("jump")
			if Input.is_action_just_pressed("jump"):
				state = MACHINE.SPIN
				jump()
			if is_on_floor():
				state = MACHINE.LANDING
		MACHINE.SPIN:
			if $AnimatedSprite2D.animation != "spin":
				$AnimatedSprite2D.play("spin")
			if is_on_floor():
				state = MACHINE.LANDING
		MACHINE.LANDING:
			if $AnimatedSprite2D.animation != "landing":
				$AnimatedSprite2D.play("landing")
#			if $AnimatedSprite2D.animation_finished:
#				state = MACHINE.RUN
		MACHINE.DEAD:
			$AnimatedSprite2D.play("dead")
			var tween = create_tween()
			tween.tween_property(self, "speed", 0, 2.5)
			tween.chain().tween_callback(result_screen_queue)
	if state != MACHINE.DEAD:
		speed += 0.07
	move_and_slide()
	clamp(speed, 0, 700)

func jump(multiplier = 1):
	velocity.y = jump_power * multiplier

func bounce():
	jump(1.5)

func collect():
	collectible_combo += 0.1
	$CollectibleComboDecay.start()
	$BerrySFX.pitch_scale = collectible_combo
	$BerrySFX.play()
	HUD.add_score_multiplier()

func hit(bounce_on_hit = true):
	if state == MACHINE.DEAD:
		return
	if mainCamera:
		if mainCamera.has_method("add_screen_shake"):
			mainCamera.add_screen_shake(1.0)
#		if mainCamera.has_method("center"):
#			mainCamera.center()
	if bounce_on_hit:
		jump()
	var musicManager = get_parent().get_node_or_null("Music")
	if musicManager != null:
		musicManager.stop()
	$ScreamSFX.play()
	death()

func death():
	state = MACHINE.DEAD

func result_screen_queue():
	get_parent().character_died()

func _on_animated_sprite_animation_finished():
	if $AnimatedSprite2D.animation == "landing":
		state = MACHINE.RUN


func _on_collectible_combo_decay_timeout():
	collectible_combo = 1

func _on_visibility_notifier_screen_exited():
	hit(false)
