#Skeleton.gd

extends CharacterBody2D

@onready var animations = $AnimatedSprite2D
@onready var changeStateTimer = $Timers/ChangeState
@onready var movingTimer = $Timers/Moving
@onready var detectionArea = $DetectionArea

var idle = false
var walking = false
var is_chasing = false
var chase_target = null

var xdir = 1
var ydir = 1
var speed = 20
var motion = Vector2()
var moving_vertical_horizontal = 1

func _ready():
	walking = true
	randomize()

func _physics_process(delta):
	var waitTime = 1
	
	if is_chasing and is_instance_valid(chase_target):
		animations.play("Chasing")
		motion = (chase_target.position - position).normalized() * speed
	else:
		if walking == true:
			animations.play("Walking")
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
		
		if idle == true:
			animations.play("Idle")
			motion.x = 0
			motion.y = 0
	
	set_velocity(motion)
	move_and_slide()

func _on_ChangeStateTimer_timeout():
	var waitTime = 1
	
	if walking == false:
		var x = randf_range(1, 2)
		if x > 1.5:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2
	
	if walking == true:
		idle = true
		walking = false
		waitTime = randf_range(1, 5)
	elif idle == true:
		walking = true
		idle = false
		waitTime = randf_range(2, 6)
	
	changeStateTimer.wait_time = waitTime
	changeStateTimer.start()

func _on_WalkingTimer_timeout():
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

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("Enemy"):
		chase_target = body
		is_chasing = true

func _on_DetectionArea_body_exited(body):
	if body == chase_target:
		chase_target = null
		is_chasing = false
