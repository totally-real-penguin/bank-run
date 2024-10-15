extends Node2D

var treasures = {
	Vector2i(0,0): 0,
	Vector2i(1,0): 1,
	Vector2i(0,4): 2,
	Vector2i(0,6): 3,
	Vector2i(0,2): 4,
}

@onready var tilemap = $TileMap
var treasure = preload('res://Scenes/treasure.tscn')


func _ready() -> void:
	EndMoney.money = 0

	for cell_pos in tilemap.get_used_cells():
		if tilemap.get_cell_source_id(cell_pos) != 1:
			continue
		var atlas = tilemap.get_cell_atlas_coords(cell_pos)
		var new_treasure = treasure.instantiate()
		new_treasure.type = treasures[atlas]
		new_treasure.set_value()
		new_treasure.position = tilemap.map_to_local(cell_pos)
		add_child(new_treasure,true)
		tilemap.set_cell(cell_pos,-1,Vector2i(-1,-1))
