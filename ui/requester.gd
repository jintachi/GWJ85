extends MarginContainer

#region Declarations
var label : Label
var in_tutorial := true
#endregion

func _ready() -> void:
	label = get_child(0)
	
	RequestManager.update_current_request.connect(_on_current_request_updated)
	_on_current_request_updated()

func _on_current_request_updated() -> void:
	if not RequestManager.current_request.requested_item:
		label.text = "No Current Request"
		return
	
	var text = "You need to deliver %s/%s %s" % [
		RequestManager.current_count,
		RequestManager.current_request.requested_count,
		RequestManager.current_request.requested_item.name]
	
	label.text = text
