extends Node2D

func _ready():
	randomize()
	var random_int = randi_range(0, 2)
	$Sprite2D.frame = random_int
