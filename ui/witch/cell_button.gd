class_name CellButton extends TextureButton

#region Declarations
signal tile_selected(cell: Cell)

@export var t_label : Label
@export var d_label : Label

var tile_resource : Cell
#endregion

func _ready() -> void:
	pressed.connect(func(): tile_selected.emit(tile_resource))

func add_text() -> void:
	t_label.text = "T%s" % tile_resource.depth_req
	d_label.text = "Cost: %sG" % tile_resource.price
