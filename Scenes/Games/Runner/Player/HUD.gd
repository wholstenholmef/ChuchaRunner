extends CanvasLayer

@export_node_path() var score_pivot
@export_node_path() var score_label
var score
@export_node_path() var multiplier_pivot
@export_node_path() var score_multiplier_label
var score_multiplier = 1.0
var player
var results_finished

func _ready():
	reset()
	if !get_tree().get_nodes_in_group("player").is_empty():
		player = get_tree().get_nodes_in_group("player")[0]

func add_score_multiplier():
	var tween = create_tween().set_parallel(true)
	#tween.tween_property(get_node(score_multiplier_label), "position:y", -5, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).as_relative()
	tween.tween_property(get_node(score_multiplier_label), "scale", Vector2(0.25, 0.25), 0.2).as_relative().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	#tween.chain().tween_property(get_node(score_multiplier_label), "position:y", 0, 0.2)
	tween.chain().tween_property(get_node(score_multiplier_label), "scale", Vector2(1.0, 1.0), 0.4)
	score_multiplier += 1
	get_node(score_multiplier_label).text = str(snapped(score_multiplier, 0.01)) + "x"

func results_sequence():
	await get_tree().create_timer(1.0).timeout
	var tween = create_tween().set_parallel(true)
	tween.tween_property(get_node(score_pivot), "position:y", 132, 3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(get_node(multiplier_pivot), "position", Vector2(208,180), 3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(results_finished_queue)

func reset():
	if !get_tree().get_nodes_in_group("player").is_empty(): 
		player = get_tree().get_nodes_in_group("player")[0]
	score = 0
	score_multiplier = 1.0
	get_node(score_label).text = str(score)
	get_node(score_multiplier_label).text = str(score_multiplier) + "x"
	get_node(score_pivot).position = Vector2.ZERO
	get_node(multiplier_pivot).position = Vector2(440, 8)

func results_finished_queue():
	results_finished = true

func _physics_process(delta):
	if is_instance_valid(player):
		score = round(player.global_position.x / 10)
		get_node(score_label).text = str(score) + "Mts."
	if results_finished:
		if Input.is_action_pressed("click"):
			results_finished = false
			get_tree().change_scene_to_file("res://Scenes/Games/Runner/World.tscn")
