# Global.gd
extends Node

var soul_selected = 1

var num_of_skulls = 0
var num_of_ghosts = 0
var num_of_souls = 350

var ghost_souls = 0
var skull_souls = 0

var camera_pos

# --------- CUTSCENES -------- #
var current_cutscene

var new_farming_zone_activated = false

# Set the number of soul coins
func set_soul_coins(value):
	num_of_souls = value
	emit_signal("coins_updated", num_of_souls)

# Set the number of ghost souls
func set_ghost_souls(value):
	ghost_souls = value
	emit_signal("ghost_souls_updated", ghost_souls)

# Set the number of skull souls
func set_skull_souls(value):
	skull_souls = value
	emit_signal("skull_souls_updated", skull_souls)

# Get the number of soul coins
func get_soul_coins():
	return num_of_souls

# Get the number of ghost souls
func get_ghost_souls():
	return ghost_souls

# Get the number of skull souls
func get_skull_souls():
	return skull_souls
	
# Get the number of skull souls
func get_soul_selected():
	return soul_selected

