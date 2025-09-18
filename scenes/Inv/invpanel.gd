extends Control

@export var InvPanelItems: Array[GameItem]
@export var itemSprintes: Array[Sprite2D]
@export var itemAmounts: Array[RichTextLabel]


func _process(_deltaTime: float) -> void:
	for x in range (InvPanelItems.size()):
		itemAmounts[x].text = str(GameGlobal.myInventory.ItemAmount(InvPanelItems[x]))
