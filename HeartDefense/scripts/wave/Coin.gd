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

func _ready() -> void:
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
		$Tween.interpolate_property(self, "position", position, 
			position+Vector2(0,-5), 0.05, Tween.TRANS_CUBIC,Tween.EASE_IN)
		tween_timer.wait_time = 0.05
		tween_timer.start()
	else:
		$Tween.interpolate_property(self, "position", position, 
			position+Vector2(0,5), 0.25, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
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
	Global.player_type[Global.PLAYER.MONEY] += 1
	queue_free()
