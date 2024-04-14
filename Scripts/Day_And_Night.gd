# DayAndNight.gd

extends StaticBody2D

var state = "day"
var change_state = false
var current_day = 1  # Keep track of the current day

@export var length_of_day = 12 # Seconds
@export var length_of_night = 8 # Seconds

# Storing references to spawned instances
var enemies = []
var summons = []

func _ready():
	_update_color_rect()
	$Timer.wait_time = length_of_day
	$Timer.start()

func _on_Timer_timeout():
	state = "night" if state == "day" else "day"
	change_state = true

func _process(delta):
	if change_state:
		change_state = false
		if state == "day":
			change_to_day()
		elif state == "night":
			change_to_night()

func _update_color_rect():
	$ColorRect.color.a = 0 if state == "day" else 150

func change_to_day():
	$AnimationPlayer.play("Night_To_Day")
	remove_night_entities()
	spawn_day_entities()
	$Timer.wait_time = length_of_day
	$Timer.start()
	current_day += 1  # Increment the current day

func change_to_night():
	$AnimationPlayer.play("Day_To_Night")
	remove_day_entities()
	spawn_night_entities()
	$Timer.wait_time = length_of_night
	$Timer.start()

func spawn_day_entities():
	var enemy_scene = load("res://Scenes/Characters/Human.tscn")
	if enemy_scene and Global.enemy_spawn_point:
		for i in range(current_day):  # Spawn enemies based on the current day
			var enemy = enemy_scene.instantiate()
			enemies.append(enemy)
			Global.enemy_spawn_point.add_child(enemy)
	else:
		print("Error loading Human.tscn or EnemySpawnPoint not found")

	if Global.get_soul_coins() >= 50 and Global.summon_spawn_point:
		var summon_scene = load("res://Scenes/Characters/Skeleton.tscn")
		if summon_scene:
			var summon = summon_scene.instantiate()
			summons.append(summon)
			Global.summon_spawn_point.add_child(summon)
			Global.set_soul_coins(Global.get_soul_coins() - 50)
		else:
			print("Error loading Skeleton.tscn")

func spawn_night_entities():
	print("Spawning night entities")

func remove_day_entities():
	var enemies_copy = enemies.duplicate()
	for enemy in enemies_copy:
		if is_instance_valid(enemy):
			enemy.queue_free()
	enemies.clear()

func remove_night_entities():
	print("Removing night entities")
