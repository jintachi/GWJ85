## Controls the UI elements that are apart of the player HUD.
extends CanvasLayer

#region Declarations
@export var witch_shop : PanelContainer

@export var gold_label : Label
#endregion

#region Publics
func update_gold(value: int) -> void:
	gold_label.text = "%s" % value
#endregion

#region Signal Callbacks
func _shop_visibility_switched() -> void:
	print("switching")
	if witch_shop.visible:
		witch_shop.hide()
	else:
		witch_shop.show()
#endregion
