extends TileMap


const WALL_COLLISION = preload("res://Scenes/Buildings/WallCollision.tscn")

const MIN_MAP_POS := Vector2(1,2)
const MAX_MAP_POS := Vector2(38,21)

var collisions:={}


func add_tile(map_pos:Vector2,tile_value:int) -> void:
	set_cellv(map_pos,tile_value)
	var coll=collisions.get(map_pos)
	if tile_value==-1 and coll!=null:
		coll.queue_free()
	elif coll==null :
		coll=WALL_COLLISION.instance()
		add_child(coll)
		coll.global_position=Vector2(8,8) + map_to_world(map_pos)
		collisions[map_pos]=coll
	update_bitmask_area(map_pos)
