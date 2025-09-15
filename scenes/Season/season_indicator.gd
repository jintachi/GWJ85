extends Node2D

@export var seaonSprint: Sprite2D
@export var markerSprite: Sprite2D
@export var activeSeason: Genum.Season = 0
@export var seasonLength: float = 30
var timer: float = 0

func _init() -> void:
	pass
	
func _process(_deltaTime: float) -> void:
	timer += _deltaTime *10
	if timer > seasonLength:
		var nextSason = activeSeason + 1
		if nextSason == 4: nextSason = 0
		activeSeason = nextSason
		timer = 0
		if activeSeason == 0: $RichTextLabel.text = "[center]SPRING"
		elif activeSeason == 1: $RichTextLabel.text = "[center]SUMMER"
		elif activeSeason == 2: $RichTextLabel.text = "[center]FALL"
		elif activeSeason == 3: $RichTextLabel.text = "[center]WINTER"
				
	var npos = (activeSeason * 300) - 600 + (timer*10)
	#var frequency: float = 4.0
	#var angle = (npos / 1200) * TAU * frequency
	markerSprite.position = Vector2(npos, 10)	
