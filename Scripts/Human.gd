extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var player_chase = false
var player = null
var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = startPosition + Vector2(3 * 32, 3 * 16)

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = (endPosition - position).normalized() * speed
	
	if player_chase and is_instance_valid(player):
		moveDirection = (player.position - position).normalized() * speed
	
	if moveDirection.length() < limit:
		changeDirection()
	
	velocity = moveDirection

func updateAnimation():
	if velocity.length() > 0:
		animations.play("Walk")
	else:
		animations.stop()

func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false
