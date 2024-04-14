#Global.gd
extends Node

var soul_selected = 1

var num_of_skulls = 0
var num_of_ghosts = 0

var soul_coins = 350
var camera_pos

# --------- CUTSCENES -------- #
var current_cutscene

var new_farming_zone_activated = false

func set_soul_coins(value):
	soul_coins = value
	emit_signal("coins_updated", soul_coins)
