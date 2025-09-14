## These are tiles that transport items from other machines.
class_name TransportTile extends Resource

#region Declarations
var tile_type := Genum.TileType.TRANSPORTER ## The type of tile this is.
@export var id : int ## The ID of the tile.
@export var carrying : GameItem ## What GameItem is being transported through.
@export var direction : Vector2i ## The direction of the transport.
#endregion

#region Helpers
#endregion
