## Handles all the main crafting that the processors require, includes loading item data
## handling craft designation, etc.
extends Node

#region Declarations
var item_atlas : AtlasTexture
var item_atlas_path : String = "res://assets/images/item_atlas.png"
var item_path : String = "res://mechanics/inventory_system/items.json"
var item_compendium : Dictionary [int, GameItem] = {}
#endregion

#region Built-Ins
func _ready() -> void:
	# Item Loading
	item_atlas = AtlasTexture.new()
	item_atlas.atlas = FileHelper.load_asset(item_atlas_path)
	_load_items(item_path)
#endregion

#region Loaders
func _load_items(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var item_db := []
	if file:
		var json_data = JSON.parse_string(file.get_as_text())
		file.close()
		
		if json_data:
			item_db = json_data
	
	for item_data in item_db:
		var item = _load_item(item_data)
		item_compendium.set(int(item_data.get("id")), item)

func _load_item(data: Dictionary) -> GameItem:
	var item = GameItem.new()
	item.name = data.get("name")
	item.description = data.get("description")
	item.value = data.get("value")
	item.purchaseable = data.get("purchaseable", false)
	
	var texture_pos = data.get("texture_pos")
	var texture_vec = Vector2i(texture_pos.get("x"), texture_pos.get("y"))
	item.texture = _load_texture(texture_vec, Vector2i(0, 0))
	return item

func _load_texture(pos: Vector2i, cell_size: Vector2i) -> AtlasTexture:
	if not item_atlas:
		push_error("There is no item_atlas assigned")
		return null
	
	var atlas : AtlasTexture = item_atlas.duplicate()
	atlas.region = Rect2(pos, cell_size)
	return atlas
#endregion
