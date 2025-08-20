extends Node2D

func _process(delta: float) -> void:
	pass

func _on_nymera_pressed() -> void:
	Gamemanager.set_p(2)
	print(Gamemanager.get_p())
	get_tree().change_scene_to_file("res://Scene/Map.tscn")

func _on_elendros_pressed() -> void:
	Gamemanager.set_p(1)
	print(Gamemanager.get_p())
	get_tree().change_scene_to_file("res://Scene/Map.tscn")
