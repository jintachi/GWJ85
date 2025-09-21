## Handles all data regarding the cell map.
extends Node

#region Declarations
signal new_cell_selected(cell: Cell)

var placeable_tile : Tile
var selected_cell : Cell :
	set(value):
		selected_cell = value
		new_cell_selected.emit(selected_cell)
#endregion

# TODO: Make another scene for selecting tiles that have been purchased
# TODO: Make a reference to a selected purchased tile
# TODO: Set a newly selected tile to the purchased tile

#region Built-Ins
func _ready() -> void:
	pass
#endregion
