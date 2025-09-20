## A neat piece of UI for pausing the game and editing settings.
extends PanelContainer

#region Declarations
@export_category("Menu")
@export var menu : MarginContainer
@export_category("Settings")
@export var settings : MarginContainer
@export var master_vslide : VSlider
@export var sfx_vslide : VSlider
@export var ui_vslide : VSlider
@export var ost_vslide : VSlider

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
	hide()
	
	_audio_setup()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		show()
#endregion

#region Setups
## Sets up all the Vsliders so that they are at the correct volume levels.
func _audio_setup() -> void:
	master_vslide.value = AudioServer.get_bus_volume_linear(Genum.BusID.MASTER)
	sfx_vslide.value = AudioServer.get_bus_volume_linear(Genum.BusID.SFX)
	ui_vslide.value = AudioServer.get_bus_volume_linear(Genum.BusID.UI)
	ost_vslide.value = AudioServer.get_bus_volume_linear(Genum.BusID.OST)
	
	# set initial volume to 60 %
	master_vslide.value *= .5
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

func _master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(Genum.BusID.MASTER, value)

func _toggle_mute_master() -> void :
	if not AudioServer.is_bus_mute(Genum.BusID.MASTER): 
		AudioServer.set_bus_mute(Genum.BusID.MASTER, true)
	else :
		AudioServer.set_bus_mute(Genum.BusID.MASTER, false)

func _sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(Genum.BusID.SFX, value)

func _toggle_mute_sfx() -> void :
	if not AudioServer.is_bus_mute(Genum.BusID.SFX): 
		AudioServer.set_bus_mute(Genum.BusID.SFX, true)
	else :
		AudioServer.set_bus_mute(Genum.BusID.SFX, false)
	
func _ui_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(Genum.BusID.UI, value)

func _toggle_mute_ui() -> void :
	if not AudioServer.is_bus_mute(Genum.BusID.UI): 
		AudioServer.set_bus_mute(Genum.BusID.UI, true)
	else :
		AudioServer.set_bus_mute(Genum.BusID.UI, false)
func _ost_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(Genum.BusID.OST, value)

func _toggle_mute_ost() -> void :
	if not AudioServer.is_bus_mute(Genum.BusID.OST): 
		AudioServer.set_bus_mute(Genum.BusID.OST, true)
	else :
		AudioServer.set_bus_mute(Genum.BusID.OST, false)
#endregion
