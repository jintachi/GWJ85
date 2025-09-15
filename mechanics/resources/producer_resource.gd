## The Main resource for handling Producers, tiles that produce a specific resource.
class_name ProducerTile extends Machine

#region Declarations
@export var produced_item : GameItem ## What the Producer should be making.
@export var production_period : int = 10 ## A measure of how many seconds it takes to produce 1 item
#endregion

func _init() -> void:
	tile_type = Genum.TileType.PRODUCER ## The type of tile this is.
