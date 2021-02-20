extends AudioStreamPlayer

var hover_select_audio_file #preload("res://Sounds/Buildings/Options/Select.wav")
var confirm_select_audio_file #preload("res://Sounds/Buildings/Options/Confirm.wav")
var play_confirm = false
func play_hover_select():
	stop()
	stream = hover_select_audio_file
	play()

func play_confirm_select():
	if !play_confirm:
		play_confirm = true
		stop()
		stream = confirm_select_audio_file
		play()




func _on_BuildWheelPlayer_finished():
	if stream == confirm_select_audio_file:
		queue_free()
