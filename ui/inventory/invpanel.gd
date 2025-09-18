extends PanelContainer

#region Declarations
@export var inv_panel_items : Array[GameItem]
@export var inv_container : GridContainer

var game_node : Node
#endregion

#region Built-Ins
func _ready() -> void:
	game_node = get_tree().get_first_node_in_group(&"game")
	
	Inventory.update_inventory.connect(_on_inventory_updated)
#endregion

#region Signal Callbacks
func _on_inventory_updated() -> void:
	pass
#endregion
