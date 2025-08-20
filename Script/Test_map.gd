extends Node2D

func _ready() -> void:
	print(Gamemanager.get_p())
	var p_value = Gamemanager.get_p()
	if p_value == 1:
		$CanvasUI/Elendros.visible = true
		$CanvasUI/Nymera.visible = false
	elif p_value == 2:
		$CanvasUI/Elendros.visible = false
		$CanvasUI/Nymera.visible = true
func _process(delta: float):
	$CanvasUI/Inventory.initialize_inventory()
