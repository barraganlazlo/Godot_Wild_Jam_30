extends Tween

onready var buildWheelNode = get_parent()
onready var fadeVar = false
onready var fadeSpeed = .01

func fade():
	if fadeVar == false:
		fadeVar = true
# warning-ignore:return_value_discarded
		stop_all()

# warning-ignore:return_value_discarded
		interpolate_property(buildWheelNode, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), fadeSpeed, Tween.TRANS_EXPO, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
		start()

