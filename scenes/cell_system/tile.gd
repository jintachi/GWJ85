## The "Cell" of the map system for creating automations.
class_name Tile extends PanelContainer

#region Delcarations
@export var tile_res : Cell :
	set(value):
		tile_res = value
		_update_textures()
@export var selected: bool = false
@export var produced_item : GameItem
@export var recipe : GameRecipe
@export var delivered_item : GameItem

@onready var label : Label = $"Label"

var selected_theme : StyleBox
var unselected_theme : StyleBox
var tick_counter : int = 1

var parent : TileGrid
#endregion

#region Built-Ins
func _ready() -> void:
	if not get_parent():
		return
	if get_parent() is TileGrid:
		parent = get_parent()
	
	set_themes()
	self.add_theme_stylebox_override("panel", unselected_theme)
	
	_update_textures()
	
	GameGlobalEvents.game_tick.connect(_on_game_tick)
	#GameGlobalEvents.place_item.connect(_on_item_placed)
#endregion

#region Helpers
func toggle_selection(is_selected: bool) -> void:

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
	Inventory.AddItem(produced_item, 1)
	if tile_res.cell_name == &"Field":
		$"MachineLayer".texture.region = Rect2(64, 0, 64, 64)

func _process_resource() -> void:
	CraftManager.request_craft(recipe)

func _deliver_resource() -> void:
	RequestManager.deliver_item(delivered_item)

func _compute_cell() -> void:
	for produce in tile_res.produced:
		Inventory.AddItem(produce.item, produce.count)
	
	for process in tile_res.processed:
		for i in range(process.count):
			var item = CraftManager.request_craft(process.recipe)
			if not item:
				continue
			Inventory.AddItem(item, 1)
	
	for delivery in tile_res.delivered:
		RequestManager.deliver_item(delivery.item, delivery.count)

func _update_textures() -> void:
	if not tile_res:
		$"MachineLayer".texture = null
		return
	
	if tile_res.cell_name == &"Field":
		$"MachineLayer".texture = tile_res.texture.duplicate()
	else:
		$"MachineLayer".texture = tile_res.texture
	label.text = "T%s" % tile_res.depth_req
#endregion

#region Signal Callbacks
func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not parent:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if selected and tile_res:
			TileMapManager.selected_cell = tile_res
		
		if Input.is_physical_key_pressed(KEY_SHIFT) or Input.is_physical_key_pressed(KEY_CTRL):
			if tile_res != TileMapManager.selected_cell:
				TileMapManager.selected_cell = null
			toggle_selection(selected)
		else:
			parent._unselect_all()
			toggle_selection(selected)
		
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		if not tile_res:
			return
		
		var removed_item := false
		match(tile_res):
			Genum.TileType.PRODUCER:
				if produced_item:
					produced_item = null
					removed_item = true
			Genum.TileType.PROCESSOR:
				if recipe:
					recipe = null
					removed_item = true
			Genum.TileType.DELIVERY:
				if delivered_item:
					delivered_item = null
					removed_item = true
		
		if not removed_item:
			tile_res = null
		
		_update_textures()

func _unselect() -> void:
	selected = false
	self.remove_theme_stylebox_override("panel")
	self.add_theme_stylebox_override("panel",unselected_theme)

func _on_game_tick() -> void:
	if not tile_res:
		return
	
	if not recipe and not produced_item and not delivered_item:
		return
	
	if tick_counter >= tile_res.op_time:
		match(tile_res.cell_type):
			Genum.TileType.PRODUCER:
				_produce_resource()
			Genum.TileType.PROCESSOR:
				_process_resource()
			Genum.TileType.DELIVERY:
				_deliver_resource()
			Genum.TileType.CELL:
				_compute_cell()
		
		tick_counter = 1
	else:
		tick_counter += 1
		
		if tile_res.cell_name == &"Field":
			if tick_counter > (tile_res.op_time * 2) / 3:
				$"MachineLayer".texture.region = Rect2(64, 64, 64, 64) 
			elif tick_counter > (tile_res.op_time) / 3:
				$"MachineLayer".texture.region = Rect2(0, 64, 64, 64)

#func _on_item_placed(item: Variant) -> void:
#	if not selected:
#		return
#	
#	if item is GameItem:
#		if tile_res.cell_type == Genum.TileType.PRODUCER:
#			produced_item = item
#		elif tile_res.cell_type == Genum.TileType.DELIVERY:
#			delivered_item = item
#	elif item is GameRecipe:
#		recipe = item
#endregion
