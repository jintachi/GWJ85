## The main class for processing items.
class_name ProcessorTile extends Resource

#region Declarations
var tile_type := Genum.TileType.PROCESSOR ## The type of tile this is.
@export var id : int ## The ID of the tile.
@export var inputs : Dictionary[int, GameItem] = {} ## All the various item inputs for crafting
var output : Array[GameItem] = [] ## All the various item outputs from crafting
#endregion
