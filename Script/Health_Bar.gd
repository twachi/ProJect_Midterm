extends TextureProgressBar

@export var player1 : Elendros
@export var player2 : Nymera

var Main_player

func _ready() -> void:
	var current_player = get_node("../../Game_manager")
	var p_value = current_player.get_p()
	if p_value == 1:
		Main_player = get_node("../../Elendros")
	elif p_value == 2:
		Main_player = get_node("../../Nymera")

func _process(delta: float) -> void:
		update()

func update():
	value = Main_player.current_health
