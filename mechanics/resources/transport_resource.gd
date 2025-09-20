## These are tiles that transport items from other machines.
class_name TransportTile extends Machine

#region Declarations
@export var carrying : GameItem ## What GameItem is being transported through.
@export var direction : Vector2i ## The direction of the transport.
#endregion

func _init() -> void:
	tile_type = Genum.TileType.TRANSPORTER

#region Helpers
#endregion
