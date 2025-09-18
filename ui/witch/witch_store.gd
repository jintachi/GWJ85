## Handles adding/subtracting from the store based on item availability.
extends PanelContainer

#region Declarations
@export var purchaseable_ref : PackedScene
@export var witch_store : VBoxContainer
@export var caravan_store : VBoxContainer

var viewing_witch : bool = true :
	set(value):
		if value:
			_open_witch_store()
		else:
			_close_witch_store()
		
		viewing_witch = value
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
func _open_witch_store() -> void:
	witch_store.get_parent().show()
	caravan_store.get_parent().hide()

func _close_witch_store() -> void:
	witch_store.get_parent().hide()
	caravan_store.get_parent().show()
#endregion
