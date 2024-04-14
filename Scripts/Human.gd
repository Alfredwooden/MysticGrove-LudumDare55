extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition

func _ready():
	startPosition = position
	# Adjust endPosition for isometric movement, x changes affect y
	endPosition = startPosition + Vector2(3 * 32, 3 * 16)  # Move 3 tiles in x and 1.5 in y

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	# Ensure the movement vector is adapted to isometric perspective
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	var animationString = "Walk"
	# Decide the animation based on direction using GDScript's conditional expression format
	if velocity.x != 0:
		animationString = "Walk_Right" if velocity.x > 0 else "Walk_Left"
	elif velocity.y != 0:
		animationString = "Walk_Down" if velocity.y > 0 else "Walk_Up"

	animations.play(animationString)


func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
