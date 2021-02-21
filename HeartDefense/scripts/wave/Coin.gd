extends Area2D

onready var life_timer: Timer = $LifeTimer
onready var tween_timer: Timer = $Tween/TweenTimer
onready var flash_timer: Timer = $FlashTimer

onready var time_till_flash: float = 5.0
onready var time_till_delete: float = 3.0
onready var state = IDLE
onready var tween_up: bool = true
enum {
	IDLE,
	FLASH,
	DELETE
}

var pick_up_sound :=preload("res://Sounds/pick up coin.wav")

const SOUND_AUTO_DELETE = preload("res://Scenes/SoundAutoDelete.tscn")


func init() -> void:
	life_timer.wait_time = time_till_flash
	life_timer.start()
	tween()


func _on_LifeTimer_timeout() -> void:
	if state == IDLE:
		flash_timer.wait_time = 0.15
		flash_timer.start()
		state = FLASH
		life_timer.wait_time = time_till_delete
		life_timer.start()
	elif state == FLASH:
		queue_free()


func tween() -> void:
	$Tween.stop_all()
	if tween_up:
		$Tween.interpolate_property(self, "global_position", global_position, 
			global_position+Vector2(0,-5), 0.05, Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween_timer.wait_time = 0.05
		tween_timer.start()
	else:
		$Tween.interpolate_property(self, "global_position", global_position, 
			global_position+Vector2(0,5), 0.25, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
		tween_timer.wait_time = 0.5
		tween_timer.start()
	$Tween.start()
	tween_up = !tween_up


func _on_Timer_timeout() -> void:
	tween()


func _on_FlashTimer_timeout() -> void:
	if modulate == Color(1.0, 1.0, 1.0, 0.5):
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 0.5)


func _on_Coin_body_entered(body) -> void:
	Global.update_coins(1)
	var instance=SOUND_AUTO_DELETE.instance()
	get_tree().get_root().add_child(instance)
	instance.global_position=global_position
	instance.play_sound(pick_up_sound)
	instance.volume_db=-6
	queue_free()
