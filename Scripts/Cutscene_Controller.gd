extends Node2D

var current_cutscene = "none"

func _process(delta):
	Global.current_cutscene = current_cutscene
	
	if Global.new_farming_zone_activated == true:
		if current_cutscene == "none":
			current_cutscene = "newFarmingZone"
