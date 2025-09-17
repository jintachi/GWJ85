## The map that the game is played on.
class_name TileGrid extends GridContainer

#region Declarations
var map : Array = [] ## The map reference of all the cells in CellGrid
var selected_tile : Tile :
	get:
		return selected_tile
	set(value):
		print("Changed Selected Tile to " + value.name)
#endregion

#region Built-Ins
func _ready() -> void:
	_setup_map()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not selected_tile:
		return
	
	if event.is_action_pressed("turn_left"):
		selected_tile.rotation -= PI / 2.
	elif event.is_action_pressed("turn_right"):
		selected_tile.rotation += PI / 2.
#endregion

#region Setup
## Sets up the map with corresponding children in the CellGrid
func _setup_map() -> void:
	var i : int = 0
	for tile in get_children():
		if not tile is Tile:
			continue
		
		if map.size() == 0:
			map.append([])
		
		if map.get(i).size() < 4:
			map.get(i).append(tile)
		else:
			i += 1
			map.append([])
			map.get(i).append(tile)
#endregion

func _UnselectAll() -> void:
	for tile in map:
		if "selected" in tile:
			tile._unselect()
