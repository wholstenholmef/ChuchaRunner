#World logic
extends Node2D

var segment_folders = "res://Scenes/Games/Runner/Segments/"
var limit_lenght : int

func _ready():
	randomize()
	HUD.reset()
	$CircleTransition.fade_in()
	limit_lenght = get_segment_lenght()
	call_new_segment()
	$DayCycle.play("cycle")
	var rand_hour = randi_range(0, 24)
	$DayCycle.seek(rand_hour)

func character_died():
	$CircleTransition.fade_out()
	await $CircleTransition.transition_finished
	get_tree().change_scene_to_file("res://Scenes/Games/Runner/resultScreen.tscn")

func call_new_segment():
	var segment = load_segment()
	var segment_instance = segment.instantiate()
	var segment_lenght = segment_instance.get_segment_lenght()
	call_deferred("add_child", segment_instance)
	segment_instance.position.x = limit_lenght
	expand_limit(segment_lenght)

func find_segments_in_folder():
	var files = []
	var dir = DirAccess.open(segment_folders)
	if dir:
		pass

func expand_limit(amount):
	limit_lenght += amount

func load_segment():
	var randi = randi_range(1, 5)
	var loaded_segment = load(segment_folders + str(randi) + ".tscn")
	return(loaded_segment)

func get_segment_lenght():
	var tilemap = get_node("StartZone")
	var segment_lenght = tilemap.get_used_rect().size.x
	var tile_size = tilemap.tile_set.tile_size.x
	return(segment_lenght * tile_size)
