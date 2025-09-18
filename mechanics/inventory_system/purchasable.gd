extends Control

@export var item: GameItem
@export var item_texture: TextureRect
@export var title: Label
@export var cost: Label

func _ready() -> void:
	item_texture.texture = item.texture
	title.text = item.name
	cost.text = "cost: %s" % item.value

func _on_press_by_1() -> void:
	GameGlobal.myInventory.AddItem(item, 1)
	GameGlobal.myInventory.PukeConent()

func _on_press_by_10() -> void:
	GameGlobal.myInventory.AddItem(item, 10)
	GameGlobal.myInventory.PukeConent()
