extends KinematicBody2D

var idle = false
var walking = false

var xdir = 1
var ydir = 1
var speed = 5

var motion = Vector2()

var moving_vertical_horizontal = 1

func _ready():
	walking = true
	randomize()

func _physics_process(delta):
	var waitTime = 1
	if walking == true:
		$AnimatedSprite.play("Walking")
		if moving_vertical_horizontal == 1:
			if xdir == -1:
				$AnimatedSprite.flip_h = true
			if xdir == 1:
				$AnimatedSprite.flip_h = false
			motion.x = speed * xdir
			motion.y = 0
		elif moving_vertical_horizontal == 2:
			motion.y = speed * ydir
			motion.x = 0
			
	if idle == true:
		$AnimatedSprite.play("Idle")
		motion.x = 0
		motion.y = 0
		
	move_and_slide(motion)

func _on_ChangeStateTimer_timeout():
	var waitTime = 1
	
	if walking == false:
		var x = rand_range(1, 2)
		if x > 1.5:
			moving_vertical_horizontal = 1
		else:
			moving_vertical_horizontal = 2
			
	
	if walking == true:
		idle = true
		walking = false
		waitTime = rand_range(1, 5)
		
	elif idle == true:
		walking = true
		idle = false
		waitTime = rand_range(2, 6)
	$ChangeStateTimer.wait_time = waitTime
	$ChangeStateTimer.start()


func _on_WalkingTimer_timeout():
	var x = rand_range(1, 2)
	var y = rand_range(1, 2)
	var waitTime = rand_range(1, 4)
	
	if x > 1.5:
		xdir = 1
	else:
		xdir = -1
	if y > 1.5:
		ydir = 1
	else:
		ydir = -1
	$WalkingTimer.wait_time = waitTime
	$WalkingTimer.start()
		
