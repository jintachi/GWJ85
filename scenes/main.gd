extends Node

@export var next_scene : PackedScene

#region Built-Ins
func _ready() -> void:
	SceneManager.main_scene = self
	SceneManager.to_next_scene(next_scene)
#endregion
