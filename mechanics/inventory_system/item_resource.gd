## The "items" that exist within the game.
class_name GameItem extends Resource

#region Declarations
@export var name : StringName = &""
@export var description: StringName = &""
@export var value : int = 1
@export var texture : AtlasTexture
@export var purchaseable : bool = false
@export var cost : int = 0
@export var producer_id : int = 0
#endregion
