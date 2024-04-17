extends CharacterBody2D

@export var speed: float = 20.0
@export var max_health: int = 3
@export var knockback_power: int = 500
@export var humans: Node
@export var idle_duration: float = 2.0
@export var walking_range: float = 50.0

@onready var animations = $AnimatedSprite2D
@onready var hurt_timer = $Timers/HurtTimer
@onready var hurt_box = $HurtBox
@onready var hit_box = $HitBox
@onready var effects = $Effects
#@onready var health_dots = [$Control/Heart_One, $Control/Heart_One2, $Control/Heart_One3]

@onready var hearts_container = $Control/HealthContainer # Contains the health dots
@onready var heart = $Control/HealthContainer/Heart # Container of the sprite
@onready var heart_sprite = $Control/HealthContainer/Heart/HeartSprite # Animated sprite with 2 frames. 0 = full, 1 = empty

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var idle_timer := $Timers/IdleTimer
@onready var movement_timer := $Timers/MovementTimer

var chase_targets = []
var current_health: int
var is_hurt: bool = false
var enemy_collisions = []
var walking_target_position: Vector2

enum MovementState {
	IDLE,
	WALKING,
	CHASING
}

var current_movement_state = MovementState.IDLE

func _ready():
	current_health = max_health
	effects.play("RESET")
	update_health_dots()
	idle_timer.wait_time = idle_duration
	idle_timer.start()

func _physics_process(delta):
	if not is_hurt:
		update_velocity()
		move_and_slide()
		update_animation()
		
		for enemy_area in enemy_collisions:
			hurt_by_enemy(enemy_area)

func update_animation():
	match current_movement_state:
		MovementState.IDLE:
			animations.play("Idle")
		MovementState.WALKING:
			animations.play("Walk")
			animations.flip_h = velocity.x < 0
		MovementState.CHASING:
			animations.play("Chasing")
			animations.flip_h = velocity.x < 0

func _on_detection_area_body_entered(body):
	if body.is_in_group("Enemy"):
		if not body in chase_targets:
			chase_targets.append(body)
		current_movement_state = MovementState.CHASING

func _on_detection_area_body_exited(body):
	if body in chase_targets:
		chase_targets.erase(body)
		if chase_targets.is_empty():
			current_movement_state = MovementState.IDLE

func update_velocity():
	match current_movement_state:
		MovementState.IDLE:
			velocity = Vector2.ZERO
		MovementState.WALKING:
			if position.distance_to(walking_target_position) <= 5.0:
				current_movement_state = MovementState.IDLE
				idle_timer.start()
			else:
				var direction = position.direction_to(walking_target_position)
				velocity = direction * speed
		MovementState.CHASING:
			if not chase_targets.is_empty():
				var closest_target = chase_targets[0]
				for target in chase_targets:
					if position.distance_to(target.position) < position.distance_to(closest_target.position):
						closest_target = target
				nav_agent.target_position = closest_target.global_position
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = direction * speed
			else:
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
	var heart_nodes = hearts_container.get_children()
	
	# Update the existing heart nodes
	for i in range(max_health):
		if i < heart_nodes.size():
			var heart_node = heart_nodes[i]
			if heart_node.has_node("HeartSprite"):
				if i < current_health:
					heart_node.get_node("HeartSprite").frame = 1  # Full heart
				else:
					heart_node.get_node("HeartSprite").frame = 0  # Empty heart
		else:
			# Create a new heart node if needed
			var new_heart = heart.duplicate() if is_instance_valid(heart) else Node2D.new()
			hearts_container.add_child(new_heart)
			if new_heart.has_node("HeartSprite"):
				new_heart.get_node("HeartSprite").frame = 1  # Empty heart

func _on_IdleTimer_timeout():
	if current_movement_state == MovementState.IDLE:
		current_movement_state = MovementState.WALKING
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		walking_target_position = position + random_direction * walking_range

func _on_MovementTimer_timeout():
	if current_movement_state == MovementState.WALKING:
		current_movement_state = MovementState.IDLE
		idle_timer.start()
