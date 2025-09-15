extends Resource

class_name Machine

#enum machine_name {PRODUCER, TRANSPORTER, PROCESSOR, DELIVERER} 
var tile_type : Genum.TileType ## The type of tile this is.
@export var machine_type: Genum.TileType
@export var id : int ## The ID of the tile.
@export var texture: AtlasTexture  ## what it looks like
@export var level: int  ## level it up

func Changed():
	emit_changed()
