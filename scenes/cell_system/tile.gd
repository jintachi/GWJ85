## The "Cell" of the map system for creating automations.
class_name Tile extends PanelContainer

#region Delcarations
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "ProcessorTile, ProducerTile, TransportTile") var tile_type : Resource
## alternatively
@export var tyleType_alternate: Machine
@export var selected: bool = false

var selected_theme : StyleBox
var unselected_theme : StyleBox

var parent : TileGrid
#endregion

#region Built-Ins
func _ready() -> void:
	report_function()
	if not get_parent():
		return
	if get_parent() is TileGrid:
		parent = get_parent()
	
	set_themes()
	self.add_theme_stylebox_override("panel",unselected_theme)

	
#endregion

#region Helpers
## Reports the function of the cell to the cell_manager for saving and quick processing.
func report_function() -> void:
	if not tile_type:
		return
	
	match(tile_type.tile_type):
		Genum.TileType.PRODUCER:
			print("Producer")
		Genum.TileType.PROCESSOR:
			print("Processor")
		Genum.TileType.TRANSPORTER:
			print("Transport")
		Genum.TileType.DELIVERY:
			print("Deliver")

func toggle_selection(is_selected:bool) -> void :
	#$Select.visible = selected
	if selected:
		parent.selected_tile = self
		self.remove_theme_stylebox_override("panel")
		self.add_theme_stylebox_override("panel",selected_theme)
	elif self.has_theme_stylebox_override("panel") :
		self.remove_theme_stylebox_override("panel")
		self.add_theme_stylebox_override("panel",unselected_theme)

	selected = !selected 

func set_themes() -> void:
	selected_theme = theme.get_stylebox("selected","Tile")
	unselected_theme = theme.get_stylebox("unselected","Tile")
	
#endregion

#region Signal Callbacks
func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not parent:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if Input.is_physical_key_pressed(KEY_SHIFT) or Input.is_physical_key_pressed(KEY_CTRL):
			toggle_selection(selected)
		else :
			parent._UnselectAll()
			toggle_selection(selected)

		
func _unselect() -> void:
	selected = false
	toggle_selection(selected)
	
#endregion
