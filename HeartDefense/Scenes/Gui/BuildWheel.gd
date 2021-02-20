extends Position2D

const MIN_DISTANCE_TO_SELECT = 20
# #Minimun origin to mouse distance to select an option, prevents accidently clicking mouse_right
signal pass_on_type(type)

onready var tween = $Tween
onready var buildWheelPlayer = $BuildWheelPlayer
onready var player = get_tree().get_nodes_in_group("Player").front()

onready var mouse_immunity = true
onready var options_list = []
onready var current_option = null
onready var old_option = null
onready var mouse_position = Vector2.ZERO
onready var selected_type = -1
onready var fading = false

func _ready():
	var build_options : Array = ["res://Scenes/Buildings/WallBuilding.tscn",
	"res://Scenes/Buildings/SpearBuilding.tscn"]
	var build_sprites : Array = ["res://Sprites/buildings/building_base.png",
	"res://Sprites/buildings/spear/building_spear_weapon.png"]
	var build_options_size = 2
	
	var max_value = build_options_size
	var angle_diff = 360.0 / float(max_value)
	var init_angle : float = 0.0
	var inst
	var option_preload = load("res://Scenes/Gui/Option.tscn")
	for i in build_options_size:
		inst = option_preload.instance()
		add_child(inst)
		inst.connect("set_type", self, "set_type")
		inst.initialize(build_sprites[i], i, max_value, init_angle)
		options_list.append(inst)
		init_angle += angle_diff
	
	$Timer.wait_time = .05
	$Timer.start()


func fade_out():
# warning-ignore:return_value_discarded
	$Tween.stop_all()

# warning-ignore:return_value_discarded
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .05, Tween.TRANS_EXPO, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	$Tween.start()


func _physics_process(_delta):
	if !fading:
		if Input.is_action_pressed("mouse_right"): # When release, destroy and send new updated build index
			mouse_position = to_local(get_global_mouse_position())
			update()
			choose_options()
		else:
			fade_out()
			fading = true
			if buildWheelPlayer != null:
				buildWheelPlayer.play_confirm_select()
			if selected_type == -1:
				player.select(1)
				player.build_wheel_allowed = false
			else:
				emit_signal("pass_on_type", selected_type)

func set_type(value : int):
	selected_type = value

func choose_options():
	if mouse_immunity:
		return
	
	var distance = position.distance_to(mouse_position)
	#If mouse is far enough from origin position to select
	if (distance > MIN_DISTANCE_TO_SELECT): 
		var new_vector : Vector2
		var vector = ((global_position - get_global_mouse_position())*Vector2(1,-1))
		new_vector = Vector2(vector.y, vector.x)
		var angle = rad2deg((new_vector).angle()) + 180
		var angle_diff = 360.0 / float(options_list.size())
		var radial_angle
		for i in options_list:
			radial_angle = i.radial_initial_angle
			if (angle >= radial_angle) and (angle_diff + radial_angle >= angle):
				if i != current_option:
					current_option = i
					if old_option == null:
						old_option = i
					current_option.set_selected(true)
					if buildWheelPlayer != null:
						buildWheelPlayer.play_hover_select()
				break
		if old_option != current_option:
			old_option.set_selected(false)
			old_option = current_option
	else:
		current_option = null
		if old_option != null:
			old_option.set_selected(false)
			old_option = null
		selected_type = -1


# Draws line from position to mouse position
func _draw():
	if !fading and !mouse_immunity:
		draw_line(position, mouse_position, Color(255, 255, 0), 1)

#Gives a short time before placing another building
func _on_Timer_timeout():
	mouse_immunity = false



func _on_Tween_tween_all_completed():
	queue_free()
