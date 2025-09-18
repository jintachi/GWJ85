extends HBoxContainer

#region Declarations
@export var InvPanelItems: Array[GameItem]
@export var itemSprintes: Array[Sprite2D]
@export var itemAmounts: Array[RichTextLabel]

var game_node : Node
#endregion

#region Built-Ins
func _ready() -> void:
	game_node = get_tree().get_first_node_in_group(&"game")

func _process(_deltaTime: float) -> void:
	for x in range (InvPanelItems.size()):
		itemAmounts[x].text = str(GameGlobal.myInventory.ItemAmount(InvPanelItems[x]))
#endregion
