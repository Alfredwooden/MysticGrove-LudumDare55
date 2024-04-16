extends CharacterBody2D

@export var speed: float = 20.0
@export var max_health: int = 3
@export var knockback_power: int = 500

@onready var animations = $AnimatedSprite2D
@onready var hurt_timer = $Timers/HurtTimer
@onready var hurt_box = $HurtBox
@onready var hit_box = $HitBox
@onready var effects = $Effects
@onready var health_dots = [$Control/Heart_One, $Control/Heart_One2, $Control/Heart_One3]
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var chase_target = null
var current_health: int
var is_hurt: bool = false
var enemy_collisions = []

enum MovementState {
	IDLE,
	CHASING
}

var current_movement_state = MovementState.IDLE

func _ready():
	current_health = max_health
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
		MovementState.CHASING:
			if is_instance_valid(chase_target):
				nav_agent.target_position = chase_target.global_position
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = direction * speed
			else:
				current_movement_state = MovementState.IDLE

func update_animation():
	match current_movement_state:
		MovementState.IDLE:
			animations.play("Idle")
		MovementState.CHASING:
			animations.play("Chasing")
			animations.flip_h = velocity.x < 0

func _on_detection_area_body_entered(body):
	if body.is_in_group("Enemy"):
		chase_target = body
		current_movement_state = MovementState.CHASING

func _on_detection_area_body_exited(body):
	if body == chase_target:
		chase_target = null
		current_movement_state = MovementState.IDLE

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
