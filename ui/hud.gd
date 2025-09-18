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
func _switch_shop_visibility(screen: Genum.ShopScreen) -> void:
	if witch_shop.visible and witch_shop.viewing_screen == screen:
		witch_shop.hide()
	elif witch_shop.visible:
		witch_shop.viewing_screen = screen
	else:
		witch_shop.show()
		witch_shop.viewing_screen = screen
#endregion

#region Signal Callbacks
func _caravan_shop_pressed() -> void:
	_switch_shop_visibility(Genum.ShopScreen.CARAVAN)

func _witch_shop_pressed() -> void:
	_switch_shop_visibility(Genum.ShopScreen.WITCH)

func _recipe_screen_pressed() -> void:
	_switch_shop_visibility(Genum.ShopScreen.RECIPE)

func _tiles_screen_pressed() -> void:
	_switch_shop_visibility(Genum.ShopScreen.SELECTOR)
#endregion
