## Handles adding/subtracting from the store based on item availability.
extends PanelContainer

#region Declarations
@export var purchaseable_ref : PackedScene
@export var witch_store : VBoxContainer
@export var caravan_store : VBoxContainer
@export var recipe_screen : VBoxContainer
@export var tile_screen : VBoxContainer

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
		
		viewing_screen = value
#endregion

#region Built-Ins
func _ready() -> void:
	_build_store()
#endregion

#region Setups
func _build_store() -> void:
	if not witch_store or not purchaseable_ref:
		return
	
	for item in CraftManager.item_compendium.values():
		if not item.purchaseable:
			continue
		var purchaseable = purchaseable_ref.instantiate()
		purchaseable.item = item
		witch_store.add_child(purchaseable)
#endregion

#region Helpers
func _select_switch(switch : VBoxContainer) -> void:
	for screen in [witch_store, caravan_store, recipe_screen, tile_screen]:
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
#endregion
