class_name hitbox
extends Area2D

func _ready():
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(area):
	if self.is_in_group("bounceable"):
		if get_parent().has_method("bounce"):
			get_parent().bounce()
		if area.get_parent().has_method("bounce"):
			area.get_parent().bounce()
	elif self.is_in_group("collectible"):
		if get_parent().has_method("collect"):
			get_parent().collect()
		if area.get_parent().has_method("collect"):
			area.get_parent().collect()
	else:
		if area.get_parent().has_method("hit"):
			area.get_parent().hit()
