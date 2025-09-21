extends Control

@export var item: GameItem
@export var item_texture: TextureRect
@export var title: Label
@export var cost: Label

func _ready() -> void:
	item_texture.texture = item.texture
	title.text = item.name
	cost.text = "sell: %s" % item.value

func _on_press_by_1() -> void:
	if Inventory.ItemAmount(item) < 1:
		print("You don't have enough!")
		return
	Inventory.RemoveItem(item, 1)
	GameGlobalEvents.gold_updated.emit(item.value)

func _on_press_by_10() -> void:
	if Inventory.ItemAmount(item) < 10:
		print("You don't have enough!")
		return
	Inventory.RemoveItem(item, 10)
	GameGlobalEvents.gold_updated.emit((10 * item.value))
