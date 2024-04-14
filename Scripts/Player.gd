# Player.gd
extends CharacterBody2D

@export var maxHealth = 3
@export var knockbackPower: int = 500

@onready var currentHealth: int = maxHealth
@onready var effects = $Effects
@onready var hurtTimer = $HurtTimer

var isHurt: bool = false

var enemyCollisions = []

signal healthChanged

var speed = 50
var isometric_ratio = Vector2(1, 0.5)
var motion = Vector2.ZERO

func _ready():
	effects.play("RESET")

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
	handleCollision()
	if !isHurt:
		for enemyArea in enemyCollisions:
			hurtByEnemy(enemyArea)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 0: currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	isHurt = true

	knockback(area.get_parent().velocity)
	effects.play("HurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func _on_area_2d_area_entered(area):
	if area.name == "HitBox":
		enemyCollisions.append(area)

func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func player():
	pass
func player_sell_method():
	pass
func player_shop_method():
	pass
