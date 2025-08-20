extends Node2D

var item_name 

func _ready():
	item_name = "Logs"
	$AnimationPlayer.play("Idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		print("collect")
		PlayerInventory.add_item(item_name, 1)
		queue_free()
		
