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

#region Helpers
func _switch_shop_visibility(cond: bool) -> void:
	if witch_shop.visible and cond:
		witch_shop.hide()
	elif witch_shop.visible:
		witch_shop.viewing_witch = !witch_shop.viewing_witch
	else:
		witch_shop.show()
#endregion

#region Signal Callbacks
func _caravan_shop_pressed() -> void:
	_switch_shop_visibility(not witch_shop.viewing_witch)

func _witch_shop_pressed() -> void:
	_switch_shop_visibility(witch_shop.viewing_witch)
#endregion
