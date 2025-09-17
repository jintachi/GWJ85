extends Control

@export var item: GameItem
@export var itemSprite: Sprite2D
@export var title: RichTextLabel
@export var cost: RichTextLabel

func _ready() -> void:
	itemSprite.texture = item.texture
	title.text = item.name
	cost.text = "cost:" + str(item.value)
	
	


func _on_buy_1_button_up() -> void:
	var a = GameGlobal.myInventory.AddItem(item, 1)	
	GameGlobal.myInventory.PukeConent()

func _on_buy_10_button_up() -> void:
	GameGlobal.myInventory.AddItem(item, 10)	
	GameGlobal.myInventory.PukeConent()
