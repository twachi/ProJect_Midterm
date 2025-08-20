extends Panel

var ItemClass = preload("res://Scene/item.tscn")
var item = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("")
	#if randi() % 2 == 0:
		#item = ItemClass.instantiate()
		#add_child(item)
		
func pickFromSlot():
	if item:
		var inventoryNode = find_parent("Inventory")
		var index = get_index() 
		PlayerInventory.inventory.erase(index)  
		remove_child(item)
		inventoryNode.add_child(item)
		item = null

	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0 , 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	
	# update global inventory
	var index = get_index()
	PlayerInventory.inventory[index] = [item.item_name, item.item_quantity]


func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instantiate()
		add_child(item)
		item.set_item(item_name,item_quantity)
	else:
		item.set_item(item_name,item_quantity)
		
	
