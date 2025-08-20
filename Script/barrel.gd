extends Node2D
var hit_count = 3

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_hit"):
		$AnimatedSprite2D.play("hit")
		hit_count -= 1
	if hit_count <= 0:
		$AnimatedSprite2D.play("broke")
		await  get_tree().create_timer(0.5).timeout
		queue_free()
