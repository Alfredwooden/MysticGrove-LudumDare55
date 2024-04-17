# DayAndNight.gd
extends StaticBody2D

var state = "day"
var change_state = false
var current_day = 1

@export var length_of_day = 12
@export var length_of_night = 8

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
	print("Changing to day")
	$AnimationPlayer.play("Night_To_Day")
	spawn_day_entities()
	$Timer.wait_time = length_of_day
	$Timer.start()
	Global.current_day += 1
	Global.set_time_of_day("day")

func change_to_night():
	$AnimationPlayer.play("Day_To_Night")
	$Timer.wait_time = length_of_night
	$Timer.start()
	Global.set_time_of_day("night")
	$SkeletonSpawnTimer.wait_time = 0.5
	$SkeletonSpawnTimer.start()
	$GhostSpawnTimer.wait_time = 0.5
	$GhostSpawnTimer.start()
	$DevilSpawnTimer.wait_time = 0.5
	$DevilSpawnTimer.start()

func spawn_day_entities():
	var num_humans = Global.current_day
	var num_barbarians = 0
	var num_angels = 0
	
	if Global.current_day >= 10:
		num_barbarians = (Global.current_day - 10) / 5 + 1
	if Global.current_day >= 20:
		num_angels = (Global.current_day - 20) / 5 + 1
	
	print("Spawning", num_humans, "humans,", num_barbarians, "barbarians, and", num_angels, "angels")
	
	var world_scene = get_node("/root/World")
	world_scene.spawn_human()
	world_scene.spawn_barbarian()
	world_scene.spawn_angel()

func spawn_skeletons_at_night():
	if Global.get_skull_souls() > 0:
		var world_scene = get_node("/root/World")
		world_scene.spawn_skeleton()

func spawn_ghosts_at_night():
	if Global.get_ghost_souls() > 0:
		var world_scene = get_node("/root/World")
		world_scene.spawn_ghost()

func spawn_devils_at_night():
	if Global.get_devil_souls() > 0:
		var world_scene = get_node("/root/World")
		world_scene.spawn_devil()

func _on_skeleton_spawn_timer_timeout():
	spawn_skeletons_at_night()

func _on_ghost_spawn_timer_timeout():
	spawn_ghosts_at_night()

func _on_devil_spawn_timer_timeout():
	spawn_devils_at_night()
