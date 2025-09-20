class_name Cell extends Resource

@export var cell_type: Genum.TileType
@export var id : int ## The ID of the tile.
@export var texture: AtlasTexture  ## what it looks like
@export var level: int  ## level it up
@export var price: int ## How much it costs
@export var depth_req : int ## The required depth level to access it.
