#@tool
extends Control

#@export_tool_button("expand") var e = _expand

@export var tileSize: int = 256
@export var baseTile: PackedScene
@export var depth: int = 0

var myTiles = {}
func _ready() -> void:
	newTile(Vector2.ZERO)
	
func _expand():
	print("expanding")
	depth +=1
	for x in range (-depth, depth+1):
		for y in range (-depth, depth+1):
			if !myTiles.has(Vector2(x,y)):
				newTile(Vector2(x,y))
	reScale()
		
func newTile(pos):
	var t = baseTile.instantiate()
	t.position = pos * (200/(depth+1))
	add_child(t)
	myTiles[Vector2.ZERO] = {"pos": pos, "tile":t }
	
func reScale():
	for t_key in myTiles:
		var tile_data = myTiles[t_key]
		tile_data.tile.scale = Vector2(1/(depth+1), 1/(depth+1))
