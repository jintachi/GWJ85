class_name InputButton extends Button

#region Declarations

var attached
#endregion

#region Built-Ins
func _ready() -> void:
	pressed.connect(_return_attached)
#endregion

#region Signal Callbacks
func _return_attached() -> void:
	GameGlobalEvents.place_item.emit(attached)
#endregion
