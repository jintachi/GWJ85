## The "Cell" of the map system for creating automations.
class_name Tile extends PanelContainer

#region Delcarations
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "ProcessorTile, ProducerTile") var tile_res : Cell :
	set(value):
		tile_res = value
		_update_values()
		_update_textures()
@export var selected: bool = false
@export var produced_item : GameItem
@export var recipe : GameRecipe
@export var delivered_item : GameItem

var selected_theme : StyleBox
var unselected_theme : StyleBox

var parent : TileGrid
#endregion

#region Built-Ins
func _ready() -> void:
	report_function()
	if not get_parent():
		return
	if get_parent() is TileGrid:
		parent = get_parent()
	
	set_themes()
	self.add_theme_stylebox_override("panel", unselected_theme)
	
	GameGlobalEvents.game_tick.connect(_on_game_tick)
	_update_textures()
	
	GameGlobalEvents.place_item.connect(_on_item_placed)
#endregion

#region Helpers
## Reports the function of the cell to the cell_manager for saving and quick processing.
func report_function() -> void:
	if not tile_res:
		return
	
	match(tile_res.tile_type):
		Genum.TileType.PRODUCER:
			print("Producer")
		Genum.TileType.PROCESSOR:
			print("Processor")
		Genum.TileType.DELIVERY:
			print("Deliver")

func toggle_selection(_is_selected:bool) -> void :

	selected = !selected
	
	#$Select.visible = selected
	if selected:
		parent.selected_tile = self
		self.remove_theme_stylebox_override("panel")
		self.add_theme_stylebox_override("panel",selected_theme)
	elif self.has_theme_stylebox_override("panel") :
		self.remove_theme_stylebox_override("panel")
		self.add_theme_stylebox_override("panel",unselected_theme)

func set_themes() -> void:
	selected_theme = theme.get_stylebox("selected","Tile")
	unselected_theme = theme.get_stylebox("unselected","Tile")

func _produce_resource() -> void:
	# TODO: Improve logic for actual production per time
	Inventory.AddItem(produced_item, 1)

func _process_resource() -> void:
	CraftManager.request_craft(recipe)

# TODO: Come back to this after request system is made.
func _deliver_resource() -> void:
	pass

func _compute_cell() -> void:
	for produce in tile_res.produced:
		Inventory.AddItem(produce.item, produce.count)
	
	for process in tile_res.processed:
		for i in range(process.count):
			var item = CraftManager.request_craft(process.recipe)
			if not item:
				continue
			Inventory.AddItem(item, 1)

func _update_textures() -> void:
	if not tile_res:
		$"MachineLayer".texture = null
		return
	
	$"MachineLayer".texture = tile_res.texture

func _update_values() -> void:
	if not tile_res:
		recipe = null
		produced_item = null
	
	if tile_res is ProducerTile:
		if tile_res.produced_item:
			produced_item = tile_res.produced_item
	elif tile_res is ProcessorTile:
		if tile_res.recipe:
			recipe = tile_res.recipe
#endregion

#region Signal Callbacks
func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not parent:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if selected and tile_res:
			GameGlobalEvents.cell_selected = tile_res
		
		if Input.is_physical_key_pressed(KEY_SHIFT) or Input.is_physical_key_pressed(KEY_CTRL):
			if tile_res != GameGlobalEvents.cell_selected:
				GameGlobalEvents.cell_selected = null
			toggle_selection(selected)
		else:
			parent._unselect_all()
			toggle_selection(selected)
		
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		if not tile_res:
			return
		
		if tile_res is ProcessorTile:
			if tile_res.recipe:
				tile_res.recipe = null
			else:
				tile_res = null
		elif tile_res is ProducerTile:
			if tile_res.produced_item:
				tile_res.produced_item = null
			else:
				tile_res = null
		elif tile_res is CellTile:
			tile_res = null

		
func _unselect() -> void:
	selected = false
	self.remove_theme_stylebox_override("panel")
	self.add_theme_stylebox_override("panel",unselected_theme)

func _on_game_tick() -> void:
	if not tile_res:
		return
	
	if not recipe and not produced_item:
		return
	
	print(tile_res)
	if tile_res is ProducerTile:
		print("Detecting Producer")
		_produce_resource()
	elif tile_res is ProcessorTile:
		_process_resource()
	elif tile_res is CellTile:
		_compute_cell()
	# TODO: Come back with DeliveryTile

func _on_item_placed(item: Variant) -> void:
	if not selected:
		return
	
	if item is GameItem:
		if tile_res.cell_type == Genum.TileType.PRODUCER:
			produced_item = item
		elif tile_res.cell_type == Genum.TileType.DELIVERY:
			delivered_item = item
	elif item is GameRecipe:
		recipe = item
#endregion
