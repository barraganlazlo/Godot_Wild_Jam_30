extends "res://scripts/buildings/Building.gd"

signal anticipate_heart_beat()
signal heart_beat()

# Number of frames per beat
# Fps = 60
# Beat_rate / 60 = # of seconds per beat
enum BEAT_RATE {
	SLOW = 100, # 3 seconds
	SLOW_MEDIUM = 80, # 2.5 seconds
	MEDIUM = 60, # 2.0 seconds
	MEDIUM_FAST = 40, # 1.5 second
	FAST = 20, # 1 second
}

enum STATE {
	IDLE,
	BEAT,
}
onready var real_hp: int = 5
onready var beat_rate: int = BEAT_RATE.SLOW setget set_beat_rate
onready var state: int = STATE.IDLE
onready var tweening_up: bool = true
onready var big_heart_beat_push: bool = false
onready var main = get_tree().get_nodes_in_group("main").front()
onready var invincible: bool = false
func _ready() -> void:
	add_to_group("Heart_Building")
	hp = 1000000
	tween_heart()
	set_beat_rate(beat_rate)

func hp_reduced()->void:
	if invincible:
		return
	.hp_reduced()
	real_hp -= 1
	if real_hp <= 0:
		hp_depleted()
		return
	if beat_rate == BEAT_RATE.SLOW:
		beat_rate = BEAT_RATE.SLOW_MEDIUM
	elif beat_rate == BEAT_RATE.SLOW_MEDIUM:
		beat_rate = BEAT_RATE.MEDIUM
	elif beat_rate == BEAT_RATE.MEDIUM:
		beat_rate = BEAT_RATE.MEDIUM_FAST
	else: 
		beat_rate = BEAT_RATE.FAST
	
	$Invince.wait_time = beat_rate / 60.0
	$Invince.start()
	invincible = true
	big_heart_beat_push = true

func hp_depleted()->void:
	if main.game_over:
		return
	$LoseSoundPlayer.play()
	main.game_lose()
	hp = 1000
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
	if big_heart_beat_push:
		var enemies: Array = get_tree().get_nodes_in_group("Enemy")
		var enemy_pos: Vector2
		var direction: Vector2 
		for i in enemies:
			enemy_pos = i.global_position
			direction = global_position.direction_to(enemy_pos)
			i.velocity += direction * 1000
			i.set_hp(1)
		big_heart_beat_push = false
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


func _on_Invince_timeout() -> void:
	invincible = false
