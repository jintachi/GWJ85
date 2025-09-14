extends Resource

class_name Machine

#enum machine_name {PRODUCER, TRANSPORTER, PROCESSOR, DELIVERER} 
@export var machine_type: Genum.TileType
@export var texture: AtlasTexture  ## what it looks like
@export var level: int  ## level it up
@export var id : int ## The ID of the tile.
@export var produced_item : GameItem ## What the Producer should be making.
@export var production_period : int = 10 ## A measure of how many seconds it takes to produce 1 item

func Changed():
	emit_changed()
