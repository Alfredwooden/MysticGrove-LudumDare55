# Player.gd

extends CharacterBody2D

@export var maxHealth = 3
@export var knockbackPower: int = 500
@export var speed: int = 50

@onready var currentHealth: int = maxHealth
@onready var effects = $Effects
@onready var hurtTimer = $HurtTimer
@onready var animatedSprite = $AnimatedSprite2D

var isHurt: bool = false
var enemyCollisions = []
var isometric_ratio = Vector2(1, 0.5)
var motion = Vector2.ZERO

signal healthChanged
signal hit_training_dummy

func _ready():
	effects.play("RESET")
	add_to_group("Player")

func _physics_process(delta):
	motion = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		motion = Vector2(speed, speed * isometric_ratio.y)
		animatedSprite.flip_h = true
	elif Input.is_action_pressed("ui_left"):
		motion = Vector2(-speed, -speed * isometric_ratio.y)
		animatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_down"):
		motion = Vector2(-speed, speed * isometric_ratio.y)
	elif Input.is_action_pressed("ui_up"):
		motion = Vector2(speed, -speed * isometric_ratio.y)

	if motion != Vector2.ZERO:
		animatedSprite.play("Walk")
	else:
		animatedSprite.play("Idle")

	Global.camera_pos = 2 if self.position.x < 15 else 1

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
	healthChanged.emit(currentHealth)
	if currentHealth <= 0:
		die()
	else:
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

func die():
	animatedSprite.play("Die")
	await animatedSprite.animation_finished
	queue_free()
	restart_game()

func restart_game():
	get_tree().reload_current_scene()
