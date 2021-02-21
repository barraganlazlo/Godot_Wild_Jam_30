extends NinePatchRect

var scale:Vector2
var grow_factor:=1.05

func _ready():
	scale=rect_scale

func _on_TextureButton_mouse_entered():
	rect_scale*=grow_factor


func _on_TextureButton_mouse_exited():
	rect_scale=scale
