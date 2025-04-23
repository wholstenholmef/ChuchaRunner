#World logic
extends Node2D

var segment_folders = "res://Scenes/Games/Runner/Segments/"
var limit_lenght : int

@export_node_path() var titlescreen 

func _ready():
	randomize()
	HUD.reset()
	HUD.hide()
	$CircleTransition.fade_in()
	limit_lenght = get_segment_lenght()
	#call_new_segment()
	$DayCycle.speed_scale = 0.1
	$DayCycle.play("cycle")
	var rand_hour = randi_range(0, 24)
	$DayCycle.seek(rand_hour)
	$Camera2D.intro()

func show_titlescreen():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(titlescreen), "modulate:a", 1, 1.0)
	await get_tree().create_timer(3.0).timeout
	$TitleScreenCanvas/TitleScreen/Credits.show()
	Global.intro_finished = true

func hide_titlescreen():
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(titlescreen), "modulate:a", 0, 0.25)

func start_game():
	Global.show_title_screen = false
	hide_titlescreen()
	HUD.show()
	$DayCycle.speed_scale = 0.4
	$Music.play()
	call_new_segment()
	get_node("Camera2D").decenter()

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
	var randi = randi_range(1, 13)
	var loaded_segment = load(segment_folders + str(randi) + ".tscn")
	return(loaded_segment)

func get_segment_lenght():
	var tilemap = get_node("StartZone")
	var segment_lenght = tilemap.get_used_rect().size.x
	var tile_size = tilemap.tile_set.tile_size.x
	return(segment_lenght * tile_size)
