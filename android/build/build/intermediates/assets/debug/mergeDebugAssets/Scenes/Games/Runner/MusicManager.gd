extends Node

func _ready():
	play()

func play():
	for stream in get_children():
		stream.play()

func stop():
	for stream in get_children():
		stream.stop()
