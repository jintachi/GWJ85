## The main class for processing items.
class_name ProcessorTile extends Machine

#region Declarations
@export var inputs : Dictionary[int, GameItem] = {} ## All the various item inputs for crafting
var output : Array[GameItem] = [] ## All the various item outputs from crafting
#endregion

func _init() -> void:
	tile_type = Genum.TileType.PROCESSOR ## The type of tile this is.
