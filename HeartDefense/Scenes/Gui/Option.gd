extends TextureProgress

signal set_type(type)

const OPTION_TEX = preload("res://Scenes/Gui/Tab.png")
const SELECTED_TEX = preload("res://Scenes/Gui/SelectedTab.png")
const T_SPD = 1.0
const T_TRANS = Tween.TRANS_ELASTIC
const T_EASE = Tween.EASE_OUT
const SPRITE_RADIUS = 48
const TWEEN_DIST = 10
const TWEEN_SCALE = Vector2(1.25,1.25)

onready var type : String
onready var index: int = 0
onready var pos : Vector2
onready var selected : bool = false setget set_selected
onready var og_sprite_pos : Vector2

onready var tween = $Tween
onready var sprite = $Sprite

func initialize(new_type : String, new_index: int, max_val : int, init_angle : float):
	type = new_type
	index = new_index
	pos = Vector2(81.0,81.0)
	max_value = max_val
	radial_initial_angle = init_angle
	value = 1
	
	# Sprite Position
	var halfway_angle = (360.0 / float(max_val)) / 2.0
	var sprite_angle = halfway_angle + init_angle - 90
	var sprite_pos_vector = Vector2(cos(deg2rad(sprite_angle)), sin(deg2rad(sprite_angle))) * SPRITE_RADIUS
	sprite.position = pos + sprite_pos_vector
	og_sprite_pos = sprite.position
	
	# Sprite Texture
	sprite.set_texture(load(new_type))
	

func set_selected(value : bool):
	var new_texture
	if value:
		new_texture = SELECTED_TEX
		emit_signal("set_type", index)
	else:
		new_texture = OPTION_TEX
	set_progress_texture(new_texture)
	tween_option(value)


func set_progress_texture(texture : Texture):
	texture_progress = texture


func tween_option(value : bool):
	if value:
		var direction = pos.direction_to(og_sprite_pos) 
		direction *= TWEEN_DIST
		
		var tween_vector = og_sprite_pos + direction
		tween.interpolate_property(sprite, "position", sprite.position, 
			tween_vector, T_SPD, T_TRANS, T_EASE)
		tween.interpolate_property(sprite, "scale", sprite.scale, 
			TWEEN_SCALE, T_SPD, T_TRANS, T_EASE)
	else:
		tween.interpolate_property(sprite, "position", sprite.position, 
			og_sprite_pos, T_SPD, T_TRANS, T_EASE)
		tween.interpolate_property(sprite, "scale", sprite.scale, 
			Vector2(1,1), T_SPD, T_TRANS, T_EASE)
	tween.start()
