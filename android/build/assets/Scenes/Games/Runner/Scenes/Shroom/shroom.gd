extends Node2D

func bounce():
	$AnimatedSprite2D.play("boing")
	$Spores.emitting = true
