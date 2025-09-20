## A simple scene transition node, though for more advanced projects will definitely start
## from here for something more complex.
extends Node

#region Declarations
var next_scene : PackedScene
var main_scene : Node
#endregion

#region Publics
func to_next_scene(n_scene: PackedScene) -> void:
	if not ((next_scene or n_scene) and main_scene):
		return
	
	for child in main_scene.get_children():
		remove_child(child)
	
	var next_scene_i = next_scene.instantiate() if next_scene else n_scene.instantiate()
	main_scene.add_child(next_scene_i)
#endregion
