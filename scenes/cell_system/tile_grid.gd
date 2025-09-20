## The map that the game is played on.
class_name TileGrid extends GridContainer

#region Declarations
var map : Array = [] ## The map reference of all the cells in CellGrid
var selected_tile : Tile :
	get:
		return selected_tile
	set(value):
		selected_tile = value
		print("Changed Selected Tile to " + value.name)
#endregion

#region Built-Ins
func _ready() -> void:
	_setup_map()
	
	GameGlobalEvents.place_cell.connect(_on_cell_placed)

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
	if map.size() > 0:
		_load_map()
		return

	for tile in get_children():
		if not tile is Tile:
			continue
		
		map.append(tile)

func _load_map() -> void:
	for old_tile in get_children():
		remove_child(old_tile)
	
	for tile in map:
		add_child(tile)
		tile.parent = self
#endregion

#region Publics
func save_to_cell() -> CellTile:
	var new_cell := CellTile.new()
	for tile in map:
		new_cell.map.append(tile.tile_res)
		if not tile.tile_res:
			continue
		
		if tile.tile_res is ProducerTile:
			if not tile.tile_res.produced_item:
				continue
			
			var packet := ItemPacket.new()
			packet.item = tile.tile_res.produced_item
			packet.count = 1
			new_cell.add_produce(packet)
		elif tile.tile_res is ProcessorTile:
			if not tile.tile_res.recipe:
				continue
			
			var item = CraftManager.request_craft(tile.tile_res.recipe)
			if not item:
				continue
			
			var packet := RecipePacket.new()
			packet.recipe = tile.tile_res.recipe
			packet.count = 1
			new_cell.add_recipe(packet)
		elif tile.tile_res is CellTile:
			for produce in tile.tile_res.produced:
				new_cell.add_produce(produce)
			
			for process in tile.tile_res.processed:
				new_cell.add_recipe(process)
	
	print(new_cell)
	return new_cell
#endregion

#region Helper
func _generate_cell_tile() -> CellTile:
	var cell_tile := CellTile.new()
	for tile in map:
		cell_tile.map.append(tile.tile_res)
		
		if not tile.tile_res:
			continue
		
		if not (tile.recipe or tile.produced_item):
			continue
		
		var produce_packet = ItemPacket.new()
		if tile.recipe:
			produce_packet.item = tile.recipe.item
			produce_packet.count = 1
		elif tile.produced_item:
			produce_packet.item = tile.produced_item
			produce_packet.count = 1
		cell_tile.add_produce(produce_packet)
	
	return cell_tile

func _clear() -> void:
	for tile in map:
		tile.tile_res = null

func _UnselectAll() -> void:
	for tile in map:
		if tile is Array:
			for c in tile :
				if "selected" in c: c._unselect()
		if "selected" in tile:
			tile._unselect()
#endregion

#region Signal Callbacks
func _on_cell_placed(cell: Cell) -> void:
	for tile in map:
		if not tile.selected:
			continue
		
		tile.tile_res = cell
#endregion
