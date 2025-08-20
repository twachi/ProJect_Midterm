extends CharacterBody2D
@export var health = 10
@export var speed = 40
@export var gravity : float = 30
@export var sprite = "Run"
var time_run = 0
var status = 1
var player_in_l = false
var player_in_r = false
var is_attack = false #เช็คว่าเข้าถึงเขตที่ตีได้รึยัง
var is_attacking = false #เช็คว่าตีอยู่มั้ย
var get_hit = false
var count = 0
var dis_check = false
@export var attack_delay = 3


func _ready() -> void:
	$AnimatedSprite2D.play(sprite)
	velocity.x = speed if randf_range(0,1)< 0.5 else -speed
	#print(velocity.x)
	
func _process(delta: float) -> void:
	if(health <= 0 ):
		$AnimatedSprite2D.stop()
		_cancel_attack()
		dis()
	if dis_check != true:
		if get_hit == true:
			print(get_hit)
		#print(is_attacking)
		count -= delta
		if get_hit == true :
			velocity.x = 0
			move_and_slide()
		elif get_hit != true:
			movement()
			
		time_run += delta
		if(count >= 0):
			$AnimatedSprite2D.modulate = Color("#fad486")
		else:
			$AnimatedSprite2D.modulate = Color("White")
		
	
	
func dis():
		dis_check = true
		_cancel_attack()  # ปิด hitbox + รีเซ็ต state
		is_attacking = false
		set_process(false)
		
		velocity.x = 0
		move_and_slide()
		$AnimatedSprite2D.play("Died")
		#print("aksnd")
		await get_tree().create_timer(2).timeout
		$AnimatedSprite2D.stop()
		$Body.disabled = true
		hide()
		await get_tree().create_timer(0.1).timeout
		queue_free()
	
func movement():
	if(is_attacking != true):
		if(player_in_l != true && player_in_r != true):
			velocity.x = speed * -status
			if($AnimatedSprite2D.flip_h):
				status = 1
				
			if !is_on_floor():
				velocity.y += gravity
			
			move_and_slide()
			
			if is_on_wall() || time_run > randi_range(5,10):
				speed = -speed
				velocity.x = speed 
				#print(velocity.x)
				time_run = 0
				#print("tm")
				$AnimatedSprite2D.flip_h = speed > 0
				
			$AnimatedSprite2D.flip_h = speed > 0
			
			if !$AnimatedSprite2D.is_playing() || $AnimatedSprite2D.animation != sprite:
				$AnimatedSprite2D.play(sprite)
				
		elif(player_in_l == true || player_in_r == true):
			follow_player()
			attack()
			
func follow_player():
		if(player_in_l == true && player_in_r != true):
			velocity.x = abs(speed)
			if(velocity.x > 0):
				$AnimatedSprite2D.flip_h = false
			
		elif(player_in_l != true && player_in_r == true):
			velocity.x = -(abs(speed))
			if(velocity.x < 0):
				$AnimatedSprite2D.flip_h = true
			
		if not is_on_floor():
			velocity.y += gravity
	
		move_and_slide()
			
			
#Attack
func attack():
	if dis_check != true :
		if player_in_l == true && is_attack == true && get_hit != true:
			is_attacking = true
			$AnimatedSprite2D.play("Attack_near")
			velocity.x = 0
			move_and_slide()

			var wait_time = attack_delay - 1.5
			var elapsed = 0.0
			var step = 0.1
			while elapsed < wait_time && dis_check != true:
				if get_hit == true:
					is_attacking = false
					return
				await get_tree().create_timer(step).timeout
				elapsed += step
			
			$attack_zone_left/CollisionShape2D.disabled = false
			
			elapsed = 0.0
			while elapsed < 2 && dis_check != true :
				if get_hit == true:
					$attack_zone_left/CollisionShape2D.disabled = true
					is_attacking = false
					return
				await get_tree().create_timer(step).timeout
				elapsed += step
			
			$attack_zone_left/CollisionShape2D.disabled = true
			is_attacking = false
		
		elif player_in_r == true && is_attack == true && get_hit != true:
			is_attacking = true
			$AnimatedSprite2D.play("Attack_near")
			velocity.x = 0
			move_and_slide()

			var wait_time = attack_delay - 1.5
			var elapsed = 0.0
			var step = 0.1
			while elapsed < wait_time && dis_check != true :
				if get_hit == true:
					is_attacking = false
					return
				await get_tree().create_timer(step).timeout
				elapsed += step
			
			$attack_zone_right/CollisionShape2D.disabled = false
			
			elapsed = 0.0
			while elapsed < 2 && dis_check != true:
				if get_hit == true:
					$attack_zone_right/CollisionShape2D.disabled = true
					is_attacking = false
					return
				await get_tree().create_timer(step).timeout
				elapsed += step
			
			$attack_zone_right/CollisionShape2D.disabled = true
			is_attacking = false
	

func _cancel_attack():
	$attack_zone_right/CollisionShape2D.set_deferred("disabled", true)
	$attack_zone_left/CollisionShape2D.set_deferred("disabled", true)
	is_attacking = false

	
#Detect Player
func _on_detect_zone_l_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player_in_l = true
		
func _on_detect_zone_l_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player_in_l = false
		
func _on_detect_zone_r_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player_in_r = true
		
func _on_detect_zone_r_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		player_in_r = false
		
func _on_area_attack_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_attack = true
		
func _on_area_attack_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_attack = false
		
func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_hit") && get_hit != true && count <= 0:
		health -= 15
		get_hit = true
		if is_attacking:
			_cancel_attack() # ปิด hitbox ทันที
		if dis_check != true :
			$AnimatedSprite2D.play("Hurt")
			await get_tree().create_timer(0.5).timeout
			get_hit = false
			count = 1.5
