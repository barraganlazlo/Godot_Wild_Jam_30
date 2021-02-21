extends "res://scripts/units/Unit.gd"

onready var building_limit: int = 100
onready var frames = animSprite.frames
var footsteps: Array =[
	preload("res://Sounds/footstep 1.wav"),
	preload("res://Sounds/footstep 2.wav"),
	preload("res://Sounds/footstep 3.wav"),
	preload("res://Sounds/footstep 4.wav"),
	preload("res://Sounds/footstep 5.wav"),
	preload("res://Sounds/footstep 6.wav"),
	preload("res://Sounds/footstep 7.wav"),
	preload("res://Sounds/footstep 8.wav")
]
const SOUND_AUTO_DELETE:= preload("res://Scenes/SoundAutoDelete.tscn")
const BUILD_WHEEL :=preload("res://Scenes/Gui/BuildWheel.tscn")

func _ready():
	._ready()
	add_to_group("Player")
	init("elf_m", 130.0, 2.0)

func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25, hp = 10):
	.init(sprite_string, spd, anim_spd, hp)
	#destination = get_tree().get_nodes_in_group("Heart_Building").front().global_position

enum {WEAPON_HAMMER,WEAPON_BOW}
onready var weapons :=[
	$AnimatedSprite/Weapons/Hammer,
	$AnimatedSprite/Weapons/Bow
]
var current_weapon:=WEAPON_BOW

# When right mouse is clicked , change tool to hammer and open build wheel
# When done placing buildings, (in hammer code) return to bow
func _process(_delta:float)-> void:
	if(Input.is_action_just_pressed("select building")):
			select(WEAPON_HAMMER)
			var build_wheel = BUILD_WHEEL.instance()
			add_child(build_wheel)
			build_wheel.connect("pass_on_type", weapons[WEAPON_HAMMER], "receive_type")



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


func _on_AnimatedSprite_frame_changed() -> void:
	print("changed")
	if animSprite.animation != "Run":
		return
	
	if animSprite.frame % 2 == 0:
		return
	
	var audio = SOUND_AUTO_DELETE.instance()
	add_child(audio)
	var select_clip = randi() % footsteps.size()
	audio.play_sound(footsteps[select_clip], -10, 0.8)
