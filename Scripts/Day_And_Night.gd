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
	#remove_night_entities()
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

func spawn_day_entities():
	var num_humans = Global.current_day
	print("Spawning", num_humans, "humans")

	# Get a reference to the World scene
	var world_scene = get_node("/root/World")

	world_scene.spawn_human(num_humans)
	world_scene.spawn_skeleton(5)

