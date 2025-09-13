extends Resource

class_name Machine

enum machine_name {PRODUCER, TRANSPORTER, PROCESSOR, DELIVERER} 

@export var type: machine_name
@export var texture: AtlasTexture
@export var level: int

func Changed():
	emit_changed()
