## Maintains data for displaying item counts to the screen.
class_name InventoryTile extends VBoxContainer

#region Declarations
var tex : TextureRect
var hbox = HBoxContainer
var item_name_label : Label
var item_count_label : Label

var game_item : GameItem

var count : int = 0
#endregion

#region Built-Ins
func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND
	size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	if not get_node_or_null("Tex") :
		tex = TextureRect.new()
		tex.texture = game_item.texture
		tex.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP
		tex.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		tex.size_flags_vertical = 0
		add_child(tex)
	if not get_node_or_null("./HBoxContainer") :
		hbox = HBoxContainer.new()		
		add_child(hbox)
	if not get_node_or_null("HBoxContainer/ItemName") :
		item_name_label = Label.new()
		item_name_label.text = "%s" % game_item.name
		item_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(item_name_label)
	if not get_node_or_null("HBoxContainer/ItemCount") :
		item_count_label = Label.new()
		item_count_label.text = "%s" % count
		item_count_label.size_flags_horizontal = Control.SIZE_SHRINK_END
		hbox.add_child(item_count_label)
	pass
	
func _setup_item(g_item:GameItem,i_count:int) -> void:
	size_flags_horizontal = Control.SIZE_EXPAND
	size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	game_item = g_item
	if get_node_or_null("LabelContainer/ItemName"):
		item_name_label.text = game_item.name
	count = i_count
	if get_node_or_null("LabelContainer/ItemCount"):
		item_count_label.text = "%s" % count
	tex = TextureRect.new()
	tex.texture = game_item.texture
	tex.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP
	tex.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	tex.size_flags_vertical = 0
	tex.texture = g_item.texture
	add_to_group(&"inv_tiles")
#endregion
