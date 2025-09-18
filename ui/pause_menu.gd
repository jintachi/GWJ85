## A neat piece of UI for pausing the game and editing settings.
extends PanelContainer

#region Declarations
@export var menu : MarginContainer
@export var settings : MarginContainer

var settings_open : bool = false :
	set(value):
		if value:
			_open_settings()
		else:
			_close_settings()
		
		settings_open = value
#endregion

#region Built-Ins
func _ready() -> void:
	#hide()
	pass
#endregion

#region Helpers
func _open_settings() -> void:
	menu.hide()
	settings.show()

func _close_settings() -> void:
	menu.show()
	settings.hide()
#endregion

#region Signal Callbacks
func _settings_switch() -> void:
	settings_open = not settings_open
#endregion
