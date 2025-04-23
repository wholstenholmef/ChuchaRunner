extends CharacterBody2D

@export var speed = 100

func _ready():
	$QuackSFX.play()

func _physics_process(delta):
	velocity.x -= speed
#	velocity.y -= 9.8
	move_and_slide()

func _on_life_span_timeout():
	self.queue_free()
