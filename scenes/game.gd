## The actual game that runs
extends Node

#region Declarations
@export var hud : CanvasLayer

@export var gold_at_start : int = 100
var gold : int = 0 
#endregion

#region Built-Ins
func _ready() -> void:
	add_to_group(&"game")
	
	MusicManager.play_song(&"MainTheme")
	
	GameGlobalEvents.gold_updated.connect(_on_gold_updated)
	_on_gold_updated(gold_at_start)
#endregion

#region Signal Callbacks
func _on_gold_updated(value: int) -> void:
	gold += value
	hud.update_gold(gold)
#endregion
