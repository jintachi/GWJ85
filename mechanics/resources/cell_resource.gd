class_name Cell extends Resource

@export var cell_type: Genum.TileType ## The type of cell it is.
@export var cell_name : StringName ## The name of the cell.
@export var id : int ## The ID of the tile.
@export var texture: AtlasTexture  ## what it looks like
@export var level: int  ## level it up
@export var price: int ## How much it costs
@export var depth_req : int ## The required depth level to access it.
@export var op_time : int ## How many ticks for an operation to occur.
