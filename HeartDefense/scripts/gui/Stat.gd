extends HBoxContainer


func _ready() -> void:
	pass # Replace with function body.

func init(stat_index, stats_node_height):
	rect_min_size.y = stats_node_height / (Global.STATS.limit + 1)
	rect_size.y = stats_node_height / (Global.STATS.limit + 1)
	var keys = Global.STATS.keys()
	
	var r_modulate: Color
	if stat_index == Global.STATS.MONSTERS_KILLED:
		r_modulate = Color(0.9, 0.9, 0.9, 1.0) # white
	elif stat_index == Global.STATS.BUILDINGS_BUILT:
		r_modulate = Color(0.1, 0.4, 1.0, 1.0) # Cyan
	elif stat_index == Global.STATS.ARROWS_SHOT:
		r_modulate = Color(0.2, 1.0, 0.3, 1.0) # green
	elif stat_index == Global.STATS.HEART_BEATS:
		r_modulate = Color(1.0, 0.3, 0.4, 1.0) # red
	elif stat_index == Global.STATS.MONEY_COLLECTED:
		r_modulate = Color(1.0, 1.0, 0.3, 1.0) # yellow
	
	var spd = 2.0
	$Tween.interpolate_property($Stat, "custom_colors/font_color", 
	Color(1.0, 1.0, 1.0, 0.0), r_modulate, spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Number, "custom_colors/font_color", 
	Color(1.0, 1.0, 1.0, 0.0), r_modulate, spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
	$Tween.interpolate_property($Stat, "rect_scale", 
	Vector2(3,3), Vector2(1,1), spd, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.interpolate_property($Number, "rect_scale", 
	Vector2(3,3), Vector2(1,1), spd, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	
	$Stat.text = str(keys[stat_index])
	$Number.text = str(Global.level_stats[stat_index])
	
	$Tween.start()
