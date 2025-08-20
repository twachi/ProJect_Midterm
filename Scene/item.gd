extends Node2D

var item_name: String
var item_quantity: int

func _ready() -> void:
	var rand_val = randi() % 4
	if rand_val == 0:
		item_name = "Healing Potion"
	elif rand_val == 1:
		item_name = "Increase Max Hp Potion"
	elif rand_val == 2:
		item_name = "Atk Potion"
	else:
		item_name = "Antidote Potion"
	
	$TextureRect.texture = load("res://Asset_Midterm/Item/" + item_name + ".png")
	
	var stack_size = JsonData.item_data[item_name]["StackSize"] as int
	item_quantity = (randi() % stack_size) + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)
		
		
func set_item(nm, qt):
	item_name = nm
	item_quantity = qt  #แปลงให้เป็น int
	$TextureRect.texture = load("res://Asset_Midterm/Item/" + item_name + ".png")
	
	var stack_size: int = JsonData.item_data[item_name]["StackSize"] as int
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)


		

func add_item_quantity(amount_to_add: int) -> void:
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)
	
func decrease_item_quantity(amount_to_remove: int) -> void:
	item_quantity -= amount_to_remove
	$Label.text = str(item_quantity)
