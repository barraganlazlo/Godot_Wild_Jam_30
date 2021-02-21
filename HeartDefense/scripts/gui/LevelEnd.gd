extends NinePatchRect

onready var result_node = $ColorRect/VBoxContainer/HBoxContainer/Result
onready var stats_node = $ColorRect/VBoxContainer/ColorRect/Scroll/Stats
onready var level_stats: Array = []
onready var level_result: String = ""
onready var index_spawn: int = 0
onready var stat_spawn_spd: float = 0.75

func _ready() -> void:
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, 200), 2.0,
	Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()
	

func init(results:String = "Won", new_level_stats: Array = []):
	level_stats = new_level_stats
	level_result = results
	result_node.text = level_result
	
	var r_modulate: Color
	if level_result == "Won":
		r_modulate = Color(0.4, 1.0, 0.5, 1.0)
	else:
		r_modulate = Color(1.0, 0.4, 0.5, 1.0)
	
	var spd = 2.0
	$Tween.interpolate_property(result_node, "custom_colors/font_color", 
	Color(1.0, 1.0, 1.0, 0.0), r_modulate, spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
	$Tween.interpolate_property(result_node, "rect_scale", 
	Vector2(8,8), Vector2(1,1), spd, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	
	$Tween.start()
	$Timer.wait_time = stat_spawn_spd
	$Timer.start()


func _on_Timer_timeout() -> void:
	if index_spawn >= Global.STATS.limit:
		return
	var inst = load("res://Scenes/Gui/Stat.tscn")
	var stat = inst.instance()
	stats_node.add_child(stat)
	var stats_node_height = stats_node.rect_size.y
	stat.init(index_spawn, stats_node_height)
	index_spawn += 1
	$Timer.wait_time = stat_spawn_spd
	$Timer.start()


func _on_Button_pressed() -> void:
	Global.player_type = Global.og_player_type.duplicate(true)
	Global.building_types = Global.og_building_types.duplicate(true)
	Global.level_stats = [0,0,0,0,0]
	Global.retry()
