#Human.gd

extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var maxHealth = 3
@export var knockbackPower: int = 500

@onready var animations = $AnimatedSprite2D
@onready var changeStateTimer = $Timers/ChangeState
@onready var movingTimer = $Timers/Moving
@onready var hurtTimer = $Timers/HurtTimer
@onready var hurtBox = $HurtBox
@onready var hitBox = $HitBox
@onready var effects = $Effects
@onready var healthDots = [$Control/Heart_One, $Control/Heart_One2, $Control/Heart_One3]

var is_chasing = false
var chase_target = null
var currentHealth = maxHealth
var isHurt: bool = false
var enemyCollisions = []

var idle = false
var walking = false
var xdir = 1
var ydir = 1
var motion = Vector2()
var moving_vertical_horizontal = 1

func _ready():
	walking = true
	randomize()
	changeStateTimer.start()
	movingTimer.start()
	effects.play("RESET")
	updateHealthDots()

func updateVelocity():
	if is_chasing and is_instance_valid(chase_target):
		motion = (chase_target.position - position).normalized() * (speed * 1.25)  # Increase speed by 25% when chasing
	else:
		if walking:
			if moving_vertical_horizontal == 1:
				if xdir == -1:
					animations.flip_h = true
				if xdir == 1:
					animations.flip_h = false
				motion.x = speed * xdir
				motion.y = 0
			elif moving_vertical_horizontal == 2:
				motion.y = speed * ydir
				motion.x = 0
		else:
			motion.x = 0
			motion.y = 0
	
	if not is_chasing and motion.length() < limit:
		if walking:
			motion = motion.normalized() * speed
		else:
			motion = Vector2.ZERO
	
	velocity = motion


func updateAnimation():
	if is_chasing and is_instance_valid(chase_target):
		animations.play("Chasing")
	elif walking:
		animations.play("Walk")
	else:
		animations.play("Idle")

func _physics_process(delta):
	if !isHurt:
		updateVelocity()
		move_and_slide()
		updateAnimation()
		
		for enemyArea in enemyCollisions:
			hurtByEnemy(enemyArea)

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player") || body.is_in_group("Summon"):
		chase_target = body
		is_chasing = true

func _on_detection_area_body_exited(body):
	if body == chase_target:
		chase_target = null
		is_chasing = false

func _on_ChangeStateTimer_timeout():
	var waitTime = 1
	
	if walking:
		idle = true
		walking = false
		waitTime = randf_range(1, 5)
	else:
		walking = true
		idle = false
		waitTime = randf_range(2, 6)
		
		var x = randf_range(1, 2)
		if x > 1.5:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2
	
	changeStateTimer.wait_time = waitTime
	changeStateTimer.start()

func _on_Moving_timeout():
	var x = randf_range(1, 2)
	var y = randf_range(1, 2)
	var waitTime = randf_range(1, 4)
	
	if x > 1.5:
		xdir = 1
	else:
		xdir = -1
	
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	
	movingTimer.wait_time = waitTime
	movingTimer.start()

func _on_HurtBox_area_entered(area):
	if area.name == "HitBox" and area.get_parent().is_in_group("Summon"):
		enemyCollisions.append(area)

func _on_HurtBox_area_exited(area):
	if area in enemyCollisions:
		enemyCollisions.erase(area)

func hurtByEnemy(area):
	if !isHurt:
		if is_instance_valid(area) and is_instance_valid(area.get_parent()):
			takeDamage(1)
			isHurt = true
			knockback(area.get_parent().velocity)
			effects.play("HurtBlink")
			hurtTimer.start()
			await hurtTimer.timeout
			effects.play("RESET")
			isHurt = false
		else:
			enemyCollisions.erase(area)

func knockback(enemyVelocity: Vector2):
	if is_instance_valid(enemyVelocity):
		var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
		velocity = knockbackDirection
		move_and_slide()

func takeDamage(damage):
	currentHealth -= damage
	updateHealthDots()
	if currentHealth <= 0:
		die()

func die():
	queue_free()

func updateHealthDots():
	for i in range(maxHealth):
		if i < currentHealth:
			healthDots[i].frame = 1
		else:
			healthDots[i].frame = 0

