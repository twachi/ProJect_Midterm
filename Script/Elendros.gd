extends CharacterBody2D

class_name Elendros

@export var player_health = 100
@export var current_health : int = player_health
const SPEED = 150.0
const JUMP_VELOCITY = -250.0
@onready var Idel_E = $Idel_Sprite
@onready var Action_Sprite = $Action_Sprite
var is_attacking = false

#for_movement
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and is_attacking == false:
		Idel_E.visible = true
		Action_Sprite.visible = false
		Idel_E.flip_h = direction<0
		Action_Sprite.flip_h = direction>0
		velocity.x = direction * SPEED
		Idel_E.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		Idel_E.play("Idle")
	
	if Input.is_action_just_pressed("attack") and is_on_floor() and is_attacking == false:
		if Action_Sprite.flip_h == false:
			$Attack_Zone_Elendros_right/CollisionShape2D.disabled = false
			#position.x -= 62 
		#print("attack")
			$Action2_Sprite.visible = true
			Idel_E.visible = false
			$Action2_Sprite.play("Attack")
			is_attacking = true
			await get_tree().create_timer(0.35).timeout
		#print("attack_done")
			$Action2_Sprite.visible = false
			$Attack_Zone_Elendros_right/CollisionShape2D.disabled = true
		else :
			$Attack_Zone_Elendros/Attack_Zone_col.disabled = false
			Action_Sprite.visible = true
			Idel_E.visible = false
			Action_Sprite.play("Attack")
			is_attacking = true
			
			await get_tree().create_timer(0.35).timeout
		#print("attack_done")
			
		is_attacking = false
		Action_Sprite.visible = false
		Idel_E.visible = true
		$Attack_Zone_Elendros/Attack_Zone_col.disabled = true
	move_and_slide()
	
func get_attack_status():
	return is_attacking

func _on_elendros_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Mon_hit"):
		$AnimationPlayer.play("hurt")
		$AnimationPlayer.play("hurt")
		current_health -= 15
