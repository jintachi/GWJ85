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
	if GameGlobal.gold - item.value < 0 :
		print("You Can't Afford This!")
		return
	GameGlobal.player_inventory.AddItem(item, 1)
	await get_tree().process_frame
	GameGlobalEvents.gold_updated.emit((-1 * item.value))
	GameGlobal.player_inventory.PukeConent()

func _on_press_by_10() -> void:
	if GameGlobal.gold - (10 * item.value) < 0 :
		print("You Can't Afford This!")
		return
	GameGlobal.player_inventory.AddItem(item, 10)
	await get_tree().process_frame
	GameGlobalEvents.gold_updated.emit((-10 * item.value))
	GameGlobal.player_inventory.PukeConent()
