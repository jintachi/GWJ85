## The actual Global containing all of the game's core information.
extends Node

#region Built-Ins
func _ready() -> void:
	# Loading up sounds and then deleting the sound_loader as it's no longer necessary
	var sound_loader = SoundLoader.new()
	sound_loader.load_audio()
	sound_loader = null
#endregion

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout

func Sum(arr):
	var tot = 0
	for n in arr:
		tot+=n
	return tot

## get all children recursively
func get_all_descendants(node: Node, result := []):
	for child in node.get_children():
		result.append(child)
		get_all_descendants(child, result)
	return result

#endregion
