extends TileMap

var main:Node2D

func _ready():
	main=get_node("/root/Main")
	for j in range(main.MIN_MAP_POS.y-1,main.MAX_MAP_POS.y+2):
		for i in range(main.MIN_MAP_POS.x-1,main.MAX_MAP_POS.x+2):
			set_cell(i,j,0)
