## Maintains data for displaying item counts to the screen.
class_name InventoryTile extends TextureRect

#region Declarations
@onready var label : Label = $"Label"

var item_name : StringName = &""
var count : int :
	set(value):
		if value <= 0:
			queue_free()
		
		count = value
		_update_count()
#endregion

#region Built-Ins
func _ready() -> void:
	add_to_group("inv_tiles")
#endregion

#region Publics
func add_to_tile(i_name: StringName, value: int) -> void:
	if i_name == item_name:
		count += value

func retrieve_count(i_name: StringName) -> int:
	if i_name == item_name:
		return count
	
	return 0

func sub_from_tile(i_name: StringName, value: int) -> void:
	if i_name == item_name:
		count -= value
#endregion

#region Helpers
func _update_count() -> void:
	label.text = "%s" % count
#endregion
