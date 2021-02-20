extends Sprite

onready var tween = $Tween
onready var label = $ColorRect/Label
onready var tween_up: bool = true
onready var gain_coin: bool = false

onready var spd: float = 0.25

func _ready() -> void:
	update_label()
	Global.connect("update_coins", self, "update_coins")

func update_coins(value):
	print(value)
	if value > 0:
		update_tally(true)
	else:
		update_tally(false)
	update_label()

func update_label():
	label.text = str(Global.player_type[Global.PLAYER.MONEY])

func update_tally(gain: bool):
	gain_coin = gain

	tween()


func tween():
	var mod = Color(1.0, 0.1, 0.2, 1.0)
	if gain_coin:
		mod = Color(0.1, 1.0, 0.5, 1.0)
	tween.stop_all()
	if tween_up:
		label.rect_scale = Vector2(1.0,1.0)
		label.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		tween.interpolate_property(label, "rect_scale", Vector2(1,1), Vector2(2.5,2.5),
			spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		tween.interpolate_property(label, "custom_colors/font_color", 
			label.get("custom_colors/font_color"), mod, spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	else:
		mod = Color(1.0, 1.0, 1.0, 1.0)
		tween.interpolate_property(label, "rect_scale", Vector2(2.5,2.5), Vector2(1.0,1.0),
			spd, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		tween.interpolate_property(label, "custom_colors/font_color", 
			label.get("custom_colors/font_color"), mod, spd, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween_up = !tween_up
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	if !tween_up:
		tween()
	
