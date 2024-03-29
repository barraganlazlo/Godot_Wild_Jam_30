extends TileMap


const WALL_COLLISION = preload("res://Scenes/Buildings/WallBuilding.tscn")



var collisions:={}

func add_tile(map_pos:Vector2,tile_value:int) -> void:
	var coll=collisions.get(map_pos)
	if tile_value==-1 and coll!=null:
		set_cellv(map_pos,-1) 
		collisions[map_pos]=null
		coll.queue_free()
	elif tile_value!=-1 and coll==null :
		set_cellv(map_pos,0)
		coll=WALL_COLLISION.instance()
		add_child(coll)
		coll.global_position=Vector2(8,8) + map_to_world(map_pos)
		collisions[map_pos]=coll
	update_bitmask_area(map_pos)
