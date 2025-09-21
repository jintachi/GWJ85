## Handles adding/subtracting from the store based on item availability.
extends PanelContainer

#region Declarations
@export var purchaseable_ref : PackedScene
@export var witch_store : VBoxContainer
@export var caravan_store : VBoxContainer
@export var recipe_screen : VBoxContainer
@export var tile_screen : VBoxContainer
@export var input_screen : VBoxContainer

@export var selectables : Array[Cell]

@export var cell_texture : AtlasTexture
@export var cell_button : PackedScene
var selected_cell_type : Cell :
	set(value):
		selected_cell_type = value
		viewing_screen = Genum.ShopScreen.INPUT

var viewing_screen : Genum.ShopScreen = Genum.ShopScreen.WITCH :
	set(value):
		match(value):
			Genum.ShopScreen.WITCH:
				_select_witch()
			Genum.ShopScreen.CARAVAN:
				_select_caravan()
			Genum.ShopScreen.RECIPE:
				_select_recipe()
			Genum.ShopScreen.SELECTOR:
				_select_tiles()
			Genum.ShopScreen.INPUT:
				_select_input(selected_cell_type)
		
		viewing_screen = value
#endregion

#region Built-Ins
func _ready() -> void:
	_build_store()
	_build_selection()
	
	GameGlobalEvents.create_cell.connect(_on_cell_tile_created)
	TileMapManager.new_cell_selected.connect(func(cell: Cell): selected_cell_type = cell)
	GameGlobalEvents.update_inventory.connect(_on_inventory_updated)
	GameGlobalEvents.close_shop.connect(func(): hide())
#endregion

#region Setups
func _build_store() -> void:
	if not caravan_store or not purchaseable_ref:
		return
	
	for child in caravan_store.get_children():
		child.queue_free()
	
	for slot in Inventory.slots:
		if not slot.item:
			continue
		
		var purchaseable = purchaseable_ref.instantiate()
		purchaseable.item = slot.item
		caravan_store.add_child(purchaseable)

func _build_selection() -> void:
	for selectable in selectables:
		build_selectable(selectable)
#endregion

#region Helpers
func build_selectable(selectable: Cell) -> void:
	var button : CellButton = cell_button.instantiate()
	button.tile_resource = selectable
	if selectable.texture:
		button.texture_normal = selectable.texture
	else:
		button.texture_normal = cell_texture
	button.tile_selected.connect(_on_cell_selected)
	tile_screen.add_child(button)
	button.add_text()

func _build_inputs(cell: Cell) -> void:
	if not cell:
		for child in input_screen.get_children():
			child.queue_free()
		return
	
	var available_items = []
	match(cell.cell_type):
		Genum.TileType.PRODUCER:
			available_items = CraftManager.grab_producable_items(cell.id)
		Genum.TileType.PROCESSOR:
			available_items = CraftManager.grab_craftable_items(cell.id)
		Genum.TileType.DELIVERY:
			available_items = CraftManager.item_compendium.values()
	
	for child in input_screen.get_children():
		child.queue_free()
	
	for item in available_items:
		var button := InputButton.new()
		if item is GameRecipe:
			button.text = item.name
		else:
			button.text = item.name
		button.attached = item
		input_screen.add_child(button)

func _select_switch(switch : VBoxContainer) -> void:
	for screen in [witch_store, caravan_store, recipe_screen, tile_screen, input_screen]:
		if screen == switch:
			switch.get_parent().show()
		else:
			screen.get_parent().hide()

func _select_witch() -> void:
	_select_switch(witch_store)

func _select_caravan() -> void:
	_select_switch(caravan_store)

func _select_recipe() -> void:
	_select_switch(recipe_screen)

func _select_tiles() -> void:
	_select_switch(tile_screen)

func _select_input(cell: Cell) -> void:
	_build_inputs(cell)
	_select_switch(input_screen)
	show()
#endregion

#region Signal Callbacks
func _on_cell_selected(cell: Cell) -> void:
	if not cell:
		return
	
	GameGlobalEvents.place_cell.emit(cell)

func _on_cell_tile_created(cell: Cell) -> void:
	build_selectable(cell)

func _on_inventory_updated() -> void:
	_build_store()
#endregion
