## The "items" that exist within the game.
class_name GameItem extends Resource

#region Declarations
@export var name : StringName = ""
@export var description: StringName = ""
@export var value : int = 1
@export var texture_pos : Vector2i
@export var texture : Texture2D
#endregion
