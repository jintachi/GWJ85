## The "Cell" of the map system for creating automations.
class_name Tile extends PanelContainer

#region Delcarations
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "ProcessorTile, ProducerTile, TransportTile") var tile_type : Resource
## alternatively
@export var tyleType_alternate: Machine
@export var selected: bool = false

var parent : CellGrid
#endregion

#region Built-Ins
func _ready() -> void:
	report_function()
	if not get_parent():
		return
	if get_parent() is CellGrid:
		parent = get_parent()
	# selection box when clicked
	$Select.visible = selected
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
#endregion

#region Signal Callbacks
func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not parent:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		parent._UnselectAll()
		selected = !selected 
		$Select.visible = selected
		if selected:
			parent.selected_tile = self
		#else:
		#	parent.selected_tile = null
		
func _unselect() -> void:
	selected = false
	$Select.visible = selected
	
#endregion
