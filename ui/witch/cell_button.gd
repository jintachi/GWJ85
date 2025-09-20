class_name CellButton extends TextureButton

#region Declarations
signal tile_selected(cell: Cell)

var tile_resource : Cell
#endregion

func _ready() -> void:
	pressed.connect(func(): tile_selected.emit(tile_resource))
