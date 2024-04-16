extends CharacterBody2D

@export var speed: float = 20.0
@export var chase_speed_multiplier: float = 1.25
@export var max_health: int = 3
@export var knockback_power: int = 500
@export var idle_wait_time_range: Vector2 = Vector2(1, 5)
@export var walking_wait_time_range: Vector2 = Vector2(2, 6)
@export var moving_wait_time_range: Vector2 = Vector2(1, 4)

@onready var animations = $AnimatedSprite2D
@onready var change_state_timer = $Timers/ChangeState
@onready var moving_timer = $Timers/Moving
@onready var hurt_timer = $Timers/HurtTimer
@onready var hurt_box = $HurtBox
@onready var hit_box = $HitBox
@onready var effects = $Effects
@onready var health_dots = [$Control/Heart_One, $Control/Heart_One2, $Control/Heart_One3]

var chase_target = null
var current_health: int
var is_hurt: bool = false
var enemy_collisions = []

var is_idle: bool = false
var is_walking: bool = true
var velocity_direction: Vector2 = Vector2.RIGHT

enum MovementState {
	IDLE,
	WALKING,
	CHASING
}

var current_movement_state = MovementState.WALKING

func _ready():
	current_health = max_health
	change_state_timer.start()
	moving_timer.start()
	effects.play("RESET")
	update_health_dots()

func _physics_process(delta):
	if not is_hurt:
		update_velocity()
		move_and_slide()
		update_animation()
		
		for enemy_area in enemy_collisions:
			hurt_by_enemy(enemy_area)

func update_velocity():
	match current_movement_state:
		MovementState.IDLE:
			velocity = Vector2.ZERO
		MovementState.WALKING:
			velocity = velocity_direction * speed
		MovementState.CHASING:
			if is_instance_valid(chase_target):
				var direction = (chase_target.position - position).normalized()
				velocity = direction * (speed * chase_speed_multiplier)
			else:
				current_movement_state = MovementState.WALKING

func update_animation():
	match current_movement_state:
		MovementState.IDLE:
			animations.play("Idle")
		MovementState.WALKING:
			animations.play("Walk")
			animations.flip_h = velocity_direction.x < 0
		MovementState.CHASING:
			animations.play("Chasing")

func _on_detection_area_body_entered(body):
	if body.is_in_group("Enemy"):
		chase_target = body
		current_movement_state = MovementState.CHASING

func _on_detection_area_body_exited(body):
	if body == chase_target:
		chase_target = null
		current_movement_state = MovementState.WALKING

func _on_change_state_timer_timeout():
	match current_movement_state:
		MovementState.IDLE:
			current_movement_state = MovementState.WALKING
			change_state_timer.wait_time = randi_range(walking_wait_time_range.x, walking_wait_time_range.y)
		MovementState.WALKING:
			current_movement_state = MovementState.IDLE
			change_state_timer.wait_time = randi_range(idle_wait_time_range.x, idle_wait_time_range.y)
	change_state_timer.start()

func _on_moving_timer_timeout():
	if current_movement_state == MovementState.WALKING:
		var random_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
		velocity_direction = random_direction if random_direction != Vector2.ZERO else Vector2.RIGHT
	moving_timer.wait_time = randi_range(moving_wait_time_range.x, moving_wait_time_range.y)
	moving_timer.start()

func _on_hurt_box_area_entered(area):
	if (area.name == "HitBox" and area.get_parent().is_in_group("Enemy")):
		enemy_collisions.append(area)

func _on_hurt_box_area_exited(area):
	if area in enemy_collisions:
		enemy_collisions.erase(area)

func hurt_by_enemy(area):
	if not is_hurt and is_instance_valid(area) and is_instance_valid(area.get_parent()):
		take_damage(1)
		is_hurt = true
		knockback(area.get_parent().velocity)
		effects.play("HurtBlink")
		hurt_timer.start()
		await hurt_timer.timeout
		effects.play("RESET")
		is_hurt = false
	else:
		enemy_collisions.erase(area)

func knockback(enemy_velocity: Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()
	await get_tree().create_timer(0.2).timeout
	velocity = Vector2.ZERO

func take_damage(damage: int):
	current_health = max(0, current_health - damage)
	update_health_dots()
	if current_health == 0:
		die()

func die():
	queue_free()

func update_health_dots():
	for i in range(max_health):
		health_dots[i].frame = 1 if i < current_health else 0

func randi_range(min_value: float, max_value: float) -> float:
	return min_value + randf() * (max_value - min_value)
