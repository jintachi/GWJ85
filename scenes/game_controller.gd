extends Node

@export var goldItem:GameItem
@export var goldAtGameStart: int = 100

func _ready() -> void:
	## start the game with 100 gold
	GameGlobal.myInventory.AddItem(goldItem, goldAtGameStart)
