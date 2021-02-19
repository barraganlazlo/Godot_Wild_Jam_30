extends "res://scripts/buildings/Building.gd"

signal anticipate_heart_beat()
signal heart_beat()

# Number of frames per beat
# Fps = 60
# Beat_rate / 60 = # of seconds per beat
enum BEAT_RATE {
	SLOW = 180, # 3 seconds
	SLOW_MEDIUM = 150, # 2.5 seconds
	MEDIUM = 120, # 2.0 seconds
	MEDIUM_FAST = 90, # 1.5 second
	FAST = 60, # 1 second
}

enum STATE {
	IDLE,
	BEAT,
}

onready var beat_rate: int = BEAT_RATE.MEDIUM_FAST setget set_beat_rate
onready var state: int = STATE.IDLE
onready var tweening_up: bool = true
onready var main = get_tree().get_nodes_in_group("main").front()

func _ready() -> void:
	hp=10000000
	tween_heart()
	set_beat_rate(beat_rate)

func hp_depleted()->void:
	if main.game_over:
		return
	get_tree().get_nodes_in_group("main").front().game_over()
	hp = 10000
	collision_layer = 0
	set_animation()
	main.game_over = true
	$Tween.stop_all()
	

# rate = # of frames per beat
# This changes the idle animation length and thus changes how often a heart beat 
# occurs
func set_beat_rate(rate: int) -> void:
	var new_rate: float = stepify(float(rate)/60.0, 0.01)
	var idle_anim = $AnimationPlayer.get_animation("Idle")
	print(new_rate)
	idle_anim.remove_track(1)
	idle_anim.length = new_rate
	var new_track = idle_anim.add_track(idle_anim.TYPE_METHOD)
	idle_anim.track_set_path(new_track, ".")
	idle_anim.track_insert_key(new_track, new_rate, {"method" : "set_animation" , "args" : ["Beat"]})

# Called from animationPlayer,
# emits a signal to all buildings and player to anticipate a heart beat
func anticipate_heart_beat() -> void:
	emit_signal("anticipate_heart_beat")

# Called from animationPlayer
# emits a signal to fire the players and buildings weapons
func heart_beat() -> void:
	Global.level_stats[Global.STATS.HEART_BEATS] += 1
	emit_signal("heart_beat")

# Used by the animation player to switch between Idle and Beat
func set_animation(animation_name: String = "Idle") -> void:
	if main.game_over:
		return
	if animation_name == "Idle":
		state = STATE.IDLE
	else:
		state = STATE.BEAT
	# "Idle" or "Beat"
	$AnimationPlayer.current_animation = animation_name

func tween_heart()-> void:
	var tween: Tween = $Tween
	if main.game_over:
		tween.stop_all()
		return
	var heart: Sprite = $Heart
	var t_trans: int = Tween.TRANS_BACK
	var t_ease: int = Tween.EASE_IN_OUT
	var t_spd: float = float(beat_rate)/ 60.0
	var old_pos: Vector2  = heart.position
	var new_pos: Vector2 = Vector2.ZERO
	tween.stop_all()
	if tweening_up:
		new_pos = old_pos - Vector2(0,10)
		tween.interpolate_property(heart, "position" ,old_pos, new_pos, t_spd, t_trans, t_ease)
		tween.interpolate_property(heart, "scale" , heart.scale, Vector2(1.5,1.5), t_spd, t_trans, t_ease)
	else:
		new_pos = old_pos + Vector2(0,10)
		tween.interpolate_property(heart, "position" ,old_pos, new_pos, t_spd, t_trans, t_ease)
		tween.interpolate_property(heart, "scale" , heart.scale, Vector2(1.0,1.0), t_spd, t_trans, t_ease)
	tweening_up = !tweening_up
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	tween_heart()
