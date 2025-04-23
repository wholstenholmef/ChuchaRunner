#Segment logic
extends Node2D

signal entered_segment

func _ready():
	randomize()
	select_obstacles()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_node("../").call_new_segment()
		#emit_signal("entered_segment")
		#load_segment()

func select_obstacles():
	var starter_obstacle_cells = $TileMap.get_used_cells_by_id(0, 3)
	starter_obstacle_cells.shuffle()
	for cell in starter_obstacle_cells:
		var current_obstacle_cells = $TileMap.get_used_cells_by_id(0, 3)
		var obstacle_count = current_obstacle_cells.size()
		if obstacle_count == 1:
			return 
		$TileMap.set_cell(0, cell, -1)

func get_segment_lenght():
	var tilemap = get_node("TileMap")
	var segment_lenght = tilemap.get_used_rect().size.x
	var tile_size = tilemap.tile_set.tile_size.x
	return(segment_lenght * tile_size)

func _on_life_span_timeout():
	self.queue_free()
