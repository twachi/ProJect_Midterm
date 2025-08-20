extends Node

var item_data: Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_data = loadData("res://Data/itemData.json")
	
func loadData(file_path):
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text := file.get_as_text()
		var json = JSON.parse_string(json_text)
		if typeof(json) == TYPE_DICTIONARY:
			return json
		else:
			push_error("JSON is not a Dictionary: %s" % file_path)
	else:
		push_error("Cannot open file: %s" % file_path)
	return {}
	
