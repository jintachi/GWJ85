## Handles adding/subtracting from the store based on item availability.
extends PanelContainer

#region Declarations
@export var purchaseable_ref : PackedScene
@export var store : VBoxContainer
#endregion

#region Built-Ins
func _ready() -> void:
	_build_store()
#endregion

#region Setups
func _build_store() -> void:
	if not store or not purchaseable_ref:
		return
	
	for item in CraftManager.item_compendium.values():
		var purchaseable = purchaseable_ref.instantiate()
		purchaseable.item = item
		store.add_child(purchaseable)
#endregion
