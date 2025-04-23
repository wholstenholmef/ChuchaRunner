extends Node2D

func bounce():
	var tween = create_tween()
	tween.tween_property($Light2D, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	$AnimatedSprite2D.play("boing")
	$Spores.emitting = true
	$boingSFX.pitch_scale = randf_range(1.0, 2.0)
	$boingSFX.play()
