#DayAndNight.gd
extends StaticBody2D

var state = "day" #Night

var change_state = false

var length_of_day = 15 # sec
var length_of_night = 8 # sec

func _ready():
	if state == "day":
		$ColorRect.color.a = 0
	elif state == "night":
		$ColorRect.color.a = 150
	

func _on_Timer_timeout():
	if state == "day":
		state = "night"
	elif state == "night":
		state = "day"

	change_state = true


func _process(delta):
	if change_state == true:
		change_state = false
		if state == "day":
			change_to_day()
		elif state == "night":
			change_to_night()

func change_to_day():
	$AnimationPlayer.play("Night_To_Day")
	$Timer.wait_time = length_of_day
	$Timer.start()
	
func change_to_night():
	$AnimationPlayer.play("Day_To_Night")
	$Timer.wait_time = length_of_night
	$Timer.start()
