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
	GameGlobalEvents.place_item.connect(_add_to_tile)

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
	var highest_depth := 0
	
	# Create the grid atlas texture
	var grid_atlas_texture = create_grid_atlas()
	if grid_atlas_texture:
		new_cell.texture = grid_atlas_texture
	
	for tile in map:
		new_cell.map.append(tile.tile_res)
		if not tile.tile_res:
			continue
		
		highest_depth = maxi(highest_depth, tile.tile_res.depth_req)
		
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
	
	new_cell.depth_req = highest_depth + 1
	return new_cell

## Creates an ImageAtlas from the current 3x3 grid showing a visual snapshot of each tile
func create_grid_atlas() -> AtlasTexture:
	# Calculate the size needed for the atlas (3x3 grid)
	# Target size: 64x64 to match existing cell tile images
	var atlas_size = Vector2i(64, 64)
	var tile_size = 21  # Each tile will be 21x21 pixels (64/3 ≈ 21)
	
	# Create a new Image for the atlas
	var atlas_image = Image.create(atlas_size.x, atlas_size.y, false, Image.FORMAT_RGBA8)
	
	# Get the tile positions in grid order (left to right, top to bottom)
	var tile_positions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0),  Vector2i(0, 0),  Vector2i(1, 0),
		Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1)
	]
	
	# Iterate through tiles in the same order as the grid
	for i in range(min(map.size(), 9)):
		var tile = map[i]
		var grid_pos = tile_positions[i]
		
		# Calculate position in atlas (0,0 to 2,2 grid positions)
		# Add 1 to grid_pos to convert from (-1,-1 to 1,1) to (0,0 to 2,2)
		var atlas_pos = Vector2i((grid_pos.x + 1) * tile_size, (grid_pos.y + 1) * tile_size)
		
		# Get the tile's texture
		var tile_texture = null
		if tile.tile_res and tile.tile_res.texture:
			if tile.tile_res.texture is AtlasTexture:
				tile_texture = tile.tile_res.texture.atlas
			else:
				tile_texture = tile.tile_res.texture
		elif tile.tile_res and tile.tile_res.texture == null:
			# If no texture, use the background texture from the tile
			var bg_layer = tile.get_node("BGLayer")
			if bg_layer and bg_layer.texture:
				tile_texture = bg_layer.texture
		
		# If we have a texture, blit it to the atlas
		if tile_texture:
			var tile_image = tile_texture.get_image()
			if tile_image:
				# Convert tile image to the same format as atlas
				if tile_image.get_format() != atlas_image.get_format():
					tile_image.convert(atlas_image.get_format())
				
				# Resize tile image to fit the atlas slot if needed
				if tile_image.get_size() != Vector2i(tile_size, tile_size):
					tile_image.resize(tile_size, tile_size)
				
				# Blit the tile image to the atlas at the correct position
				atlas_image.blit_rect(tile_image, Rect2i(Vector2i.ZERO, Vector2i(tile_size, tile_size)), atlas_pos)
		else:
			# Fill with transparent/empty color if no texture
			var empty_color = Color.TRANSPARENT
			for x in range(tile_size):
				for y in range(tile_size):
					atlas_image.set_pixel(atlas_pos.x + x, atlas_pos.y + y, empty_color)
	
	# Create a new ImageTexture from the atlas image
	var atlas_texture = ImageTexture.new()
	atlas_texture.set_image(atlas_image)
	
	# Create an AtlasTexture resource
	var atlas_resource = AtlasTexture.new()
	atlas_resource.atlas = atlas_texture
	atlas_resource.region = Rect2(Vector2.ZERO, Vector2(atlas_size))
	
	# Save the atlas texture to a file for persistence
	var save_path = "res://assets/images/cell_atlases/cell_atlas_" + str(Time.get_unix_time_from_system()) + ".png"
	
	# Ensure the directory exists
	var dir = DirAccess.open("res://assets/images/")
	if not dir.dir_exists("cell_atlases"):
		dir.make_dir("cell_atlases")
	
	# Save the image using the Image.save_png() method
	var save_success = atlas_image.save_png(save_path)
	if save_success == OK:
		print("Cell atlas saved to: ", save_path)
	else:
		print("Failed to save cell atlas to: ", save_path)
	
	# Use the atlas_texture we created directly (don't try to reload from disk immediately)
	# The saved file will be available for future use, but we use the in-memory texture for now
	
	return atlas_resource
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

func _add_to_tile(item: Variant) -> void:
	for tile in map:
		if not tile.selected or not tile.tile_res:
			continue
		
		if item is GameRecipe:
			tile.tile_res.recipe = item
		elif item is GameItem:
			tile.tile_res.produced_item = item

func _clear() -> void:
	for tile in map:
		tile.tile_res = null

func _unselect_all() -> void:
	for tile in map:
		if tile is Array:
			for c in tile :
				if "selected" in c: c._unselect()
		if "selected" in tile:
			tile._unselect()
#endregion

#region Signal Callbacks
func _on_cell_placed(cell: Cell) -> void:
	if cell.depth_req > GameGlobal.level:
		return
	
	for tile in map:
		if not tile.selected:
			continue
		
		tile.tile_res = cell
#endregion
