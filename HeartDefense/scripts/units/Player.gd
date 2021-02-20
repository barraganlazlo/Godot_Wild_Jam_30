extends "res://scripts/units/Unit.gd"

onready var building_limit: int = 100
onready var build_wheel_allowed:bool = false

func _ready():
	._ready()
	add_to_group("Player")
	init("elf_m", 120.0, 2.0)

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25, hp = 10):
	.init(sprite_string, spd, anim_spd, hp)
	#destination = get_tree().get_nodes_in_group("Heart_Building").front().global_position

onready var weapons :=[
	$AnimatedSprite/Weapons/Hammer,
	$AnimatedSprite/Weapons/Bow
]
var current_weapon:=1

# When right mouse is clicked , change tool to hammer and open build wheel
# When done placing buildings, (in hammer code) return to bow
func _process(_delta:float)-> void:
	if(Input.is_action_just_pressed("mouse_right")):
		if !build_wheel_allowed:
			build_wheel_allowed = true
			#var target_weapon:=(current_weapon+1) % weapons.size()
			select(0)
			var inst = load("res://Scenes/Gui/BuildWheel.tscn")
			var build_wheel = inst.instance()
			add_child(build_wheel)
			build_wheel.connect("pass_on_type", weapons[0], "receive_type")



func _physics_process(delta :float)-> void:
	destination = global_position
	var new_destination: Vector2 = Vector2.ZERO
	new_destination.x= Input.get_action_strength("right") - Input.get_action_strength("left")
	new_destination.y= Input.get_action_strength("down") - Input.get_action_strength("up")
	if new_destination == Vector2.ZERO:
		set_animation("Idle")
	else:
		set_animation("Run")
	destination += new_destination
	
	._physics_process(delta)
	var aim_direction:=get_local_mouse_position()
	set_flip(aim_direction)

func select(target_weapon)-> void:
	if target_weapon==current_weapon:
		return
	weapons[target_weapon].activate()
	weapons[current_weapon].desactivate()
	current_weapon=target_weapon

func show_building_range(limit):
	building_limit = limit
	update()

func _draw():
	var player_pos: Vector2 = global_position
	var br = building_limit
	var new_vec = (player_pos.snapped(Vector2(16,16)))
	draw_rect(Rect2(-br/2, - br/2, br, br), Color.aqua, false)
