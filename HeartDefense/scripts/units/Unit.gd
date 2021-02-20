extends KinematicBody2D

onready var collisionShape2D = $CollisionShape2D
onready var animSprite = $AnimatedSprite

# "orge", "knight", "goblin", etc (use init() func to set sprite to whatever)
onready var type: String = ""

onready var velocity: Vector2 = Vector2.ZERO
onready var destination: Vector2 = Vector2.ZERO
onready var direction: Vector2 = Vector2.ZERO
onready var move_spd: float = 100.0 setget set_move_spd
onready var animation_spd: float = 2.25 setget set_animation_spd

# Ignore this var \/
onready var list_of_obj_types: Array = []

var hp: int = 10 setget set_hp

func take_damage(value: int, knockback: Vector2)-> void:
	set_hp(hp-value)
	velocity += knockback

	

func set_hp(value: int):
	hp = value
	if hp <= 0:
		hp_depleted()
	else:
		hp_reduced()

func hp_depleted():
	var inst = load("res://Scenes/Particles/Bomb.tscn")
	var particle = inst.instance()
	get_tree().get_nodes_in_group("ysort").front().add_child(particle)
	particle.global_position = global_position
	Global.level_stats[Global.STATS.MONSTERS_KILLED] += 1
	queue_free()

func hp_reduced():
	var timer
	if has_node("FlashTimer"):
		timer = get_node("FlashTimer")
	else: 
		var inst = load("res://shaders/FlashTimer.tscn")
		timer = inst.instance()
		add_child(timer)
		timer.name = "FlashTimer"
	timer.init(0.5)


func set_move_spd(value: float)-> void:
	move_spd = value

func set_animation_spd(value: float)-> void:
	animation_spd = value
	animSprite.speed_scale = animation_spd

func set_animation(value: String):
	if value == "Idle" or value == "Run":
		animSprite.animation = value


func init(sprite_string: String = "ogre", spd: float = 100.0, anim_spd: float = 2.25, new_hp: int = 10):
	type = sprite_string
	set_move_spd(spd)
	set_animation_spd(anim_spd)
	set_hp(new_hp)
	
	var res: String = ("res://Sprites/mobs/" + type + "//" + type) #ogre_idle_anim_f0" + ".png"
	var frames = animSprite.frames
	
	# Remove Idle And Run Animation (if any)
	if frames.has_animation("Idle"):
		frames.remove_animation("Idle")
	if frames.has_animation("Run"):
		frames.remove_animation("Run")
	
	# Idle And Run Animation
	frames.add_animation("Idle")
	frames.add_animation("Run")
	var frame_res: String = ""
	var frame_tex: Texture
	var frame_pos: float = 10.0
	for i in 4:
		frame_res = res + "_idle_anim_f" + str(i) + ".png"
		frame_tex = load(frame_res)
		frames.add_frame("Idle", frame_tex, float(i)/frame_pos)
		
		frame_res = res + "_run_anim_f" + str(i) + ".png"
		frame_tex = load(frame_res)
		frames.add_frame("Run", frame_tex, float(i)/frame_pos)
	set_animation("Idle")
	animSprite.playing = true

func _physics_process(delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(destination)
	velocity = velocity.move_toward(direction * move_spd ,1000.0 * delta)
	move_and_slide(velocity)

func set_flip(looking_direction: Vector2):
	direction = looking_direction
	if looking_direction.x < 0:
		animSprite.set_scale(Vector2(-1,1))
	elif looking_direction.x > 0:
		animSprite.set_scale(Vector2(1,1))


func set_shader(value):
	var inst = null
	if value != null:
		inst = load(value)
	list_of_obj_types = []
	deep_search(self, AnimatedSprite)
	for i in list_of_obj_types:
		i.material = inst

func deep_search(object, node_type):
	if object.get_child_count() == 0:
		if object is node_type:
			list_of_obj_types.append(object)
	else:
		for i in object.get_children():
			deep_search(i, node_type)
