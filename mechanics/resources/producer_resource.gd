## The Main resource for handling Producers, tiles that produce a specific resource.
class_name ProducerTile extends Resource

#region Declarations
var tile_type := Genum.TileType.PRODUCER ## The type of tile this is.
@export var id : int ## The ID of the tile.
@export var produced_item : GameItem ## What the Producer should be making.
@export var production_period : int = 10 ## A measure of how many seconds it takes to produce 1 item
#endregion
