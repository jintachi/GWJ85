extends Control

@export var availableRecipies: Array[CraftingRecipe]
@export var recipeImage: Sprite2D
var selector = 0


func _ready() -> void:
	updateRecipe()
	
	
func updateRecipe() -> void:
	recipeImage.texture = availableRecipies[selector].item.texture
	var numI = availableRecipies[selector].ingredients.size()
	if numI < 4: $"HBoxContainer/Ingredient 4".visible= false
	else: $"HBoxContainer/Ingredient 4".visible= true
	if numI < 3: $"HBoxContainer/Ingredient 3".visible= false
	else: $"HBoxContainer/Ingredient 3".visible= true
	if numI < 2: $"HBoxContainer/Ingredient 2".visible= false
	else: $"HBoxContainer/Ingredient 2".visible= true
	
	$"HBoxContainer/Ingredient 1/Sprite2D".texture = availableRecipies[selector].ingredients[0].item.texture
	$"HBoxContainer/Ingredient 1/RichTextLabel".text = "[center]" + str(availableRecipies[selector].ingredients[0].amount)
	if numI > 1:
		$"HBoxContainer/Ingredient 2/Sprite2D".texture = availableRecipies[selector].ingredients[1].item.texture
		$"HBoxContainer/Ingredient 2/RichTextLabel".text = "[center]" + str(availableRecipies[selector].ingredients[1].amount)
	if numI > 2:
		$"HBoxContainer/Ingredient 3/Sprite2D".texture = availableRecipies[selector].ingredients[2].item.texture
		$"HBoxContainer/Ingredient 3/RichTextLabel".text = "[center]" + str(availableRecipies[selector].ingredients[2].amount)
	if numI > 3:
		$"HBoxContainer/Ingredient 4/Sprite2D".texture = availableRecipies[selector].ingredients[3].item.texture
		$"HBoxContainer/Ingredient 4/RichTextLabel".text = "[center]" + str(availableRecipies[selector].ingredients[3].amount)

func _on_left_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selector-=1
		if selector <0: 
			selector= availableRecipies.size()-1
	updateRecipe()


func _on_right_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selector +=1
		if selector>= availableRecipies.size():
			selector=0
	updateRecipe()
			
