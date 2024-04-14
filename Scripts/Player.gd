extends CharacterBody2D

var speed = 50
var isometric_ratio = Vector2(1, 0.5)  # This reflects the 32x16 tile dimension
var motion = Vector2.ZERO

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("Sidewalk")
		$AnimatedSprite2D.flip_h = true
		motion = Vector2(speed, speed * isometric_ratio.y)
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("Sidewalk")
		$AnimatedSprite2D.flip_h = false
		motion = Vector2(-speed, -speed * isometric_ratio.y)
	elif Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.play("Down")
		motion = Vector2(-speed, speed * isometric_ratio.y)
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite2D.play("Up")
		motion = Vector2(speed, -speed * isometric_ratio.y)
	else:
		$AnimatedSprite2D.play("Idle")
		motion = Vector2.ZERO
		
	if self.position.x < 15:
		Global.camera_pos = 2
	else:
		Global.camera_pos = 1
	
	set_velocity(motion)
	move_and_slide()

func player():
	pass
func player_sell_method():
	pass
func player_shop_method():
	pass
