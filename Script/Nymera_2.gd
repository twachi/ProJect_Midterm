extends CharacterBody2D

class_name Nymera

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

@onready var Idle_Sprite = $Idle_Sprite
@onready var Action_Sprite = $Action_Sprite
@onready var Jump_Sprite = $Jump_Sprite
@onready var Jump2_Sprite = $Jump2_Sprite

var is_attacking = false
var is_jumping = false
var is_flipped = false

@export var player_health = 100
@export var current_health : int = player_health

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	movement()
	
func movement():
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if $Idle_Sprite.flip_h == true:
			velocity.y = JUMP_VELOCITY
			Idle_Sprite.visible = false
			Action_Sprite.visible = false
			Jump_Sprite.visible = false
			Jump2_Sprite.visible = true
			Jump2_Sprite.play("Jump")
			is_jumping = true
			print("flip_jump!!")
			await get_tree().create_timer(0.45).timeout
			is_jumping = false
		elif is_flipped == false:
			velocity.y = JUMP_VELOCITY
			Idle_Sprite.visible = false
			Action_Sprite.visible = false
			Jump2_Sprite.visible = false
			Jump_Sprite.visible = false
			Jump_Sprite.visible = true
			Jump_Sprite.play("Jump")
			is_jumping = true
			await get_tree().create_timer(0.5).timeout
			is_jumping = false
	if is_jumping != true :
		# Movement 
		var direction := Input.get_axis("left", "right")
		if direction != 0 and not is_attacking:
			velocity.x = direction * SPEED
			Idle_Sprite.visible = false
			Jump_Sprite.visible = false
			Action_Sprite.visible = true
			Jump2_Sprite.visible = false
			Action_Sprite.flip_h = direction > 0
			Idle_Sprite.flip_h = direction < 0
			Action_Sprite.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if not is_attacking and is_on_floor():
				Idle_Sprite.visible = true
				Action_Sprite.visible = false
				Jump_Sprite.visible = false
				Jump2_Sprite.visible = false
				Idle_Sprite.play("Idle_2")
					
						

	# Attack 
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking && $Idle_Sprite.flip_h == true:
		is_attacking = true

		Idle_Sprite.visible = false
		Jump_Sprite.visible = false
		Action_Sprite.visible = true
		Jump2_Sprite.visible = false
		Action_Sprite.play("Attack 1")
		$attack_zone_right/CollisionShape2D.disabled = false
		await get_tree().create_timer(0.35).timeout
		$attack_zone_right/CollisionShape2D.disabled = true
		is_attacking = false
		Idle_Sprite.visible = true
		Action_Sprite.visible = false
		Jump_Sprite.visible = false
		Jump2_Sprite.visible = false
		Idle_Sprite.play("Idle_2")
	
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking && $Idle_Sprite.flip_h == false:
		is_attacking = true

		Idle_Sprite.visible = false
		Jump_Sprite.visible = false
		Action_Sprite.visible = true
		Jump2_Sprite.visible = false
		Action_Sprite.play("Attack 1")
		$attack_zone_left/CollisionShape2D.disabled = false
		await get_tree().create_timer(0.35).timeout
		$attack_zone_left/CollisionShape2D.disabled = true
		is_attacking = false
		Idle_Sprite.visible = true
		Action_Sprite.visible = false
		Jump_Sprite.visible = false
		Jump2_Sprite.visible = false
		Idle_Sprite.play("Idle_2")

	move_and_slide()
	


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Mon_hit"):
		current_health -= 15
		$Action_Sprite.play("Hurt")
		await get_tree().create_timer(0.35).timeout
		
