extends Node2D

var player
var hud
var hud_points

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	hud = player.get_hud()

func collect():
	var own_pos = self.get_global_transform_with_canvas()
	var origin = own_pos.get_origin()
	call_deferred("reparent", hud)
	set_deferred("position", origin)
	$hitbox/CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.set_deferred("frame", 1)
	var tween = create_tween()
	var corner_destination = Vector2(592, 32)

#	var corner_destination = Vector2(564 + self.position.x, 32)
	tween.tween_property(self, "global_position", corner_destination, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 1)
	tween.chain().tween_callback(queue_free)
