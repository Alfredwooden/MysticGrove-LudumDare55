# Global.gd

extends Node

var soul_selected = 1
var num_of_skulls = 0
var num_of_ghosts = 0
var num_of_souls = 500
var ghost_souls = 0
var skull_souls = 0

var camera_pos
var enemy_spawn_point
var summon_spawn_point

var time_of_day = "day"
var current_day = 1

# --------- CUTSCENES -------- #
var current_cutscene
var new_farming_zone_activated = false

# --------- SPAWNED ENTITIES -------- #
var num_humans_spawned = 0
var num_skeletons_spawned = 0

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

# Function to set the time of day status
func set_time_of_day(value):
	time_of_day = value

# Function to get the time of day status
func get_time_of_day():
	return time_of_day

# Function to update the number of spawned humans
func update_num_humans_spawned(num_spawned):
	num_humans_spawned += num_spawned

# Function to update the number of spawned skeletons
func update_num_skeletons_spawned(num_spawned):
	num_skeletons_spawned += num_spawned

# Function to get the number of spawned humans
func get_num_humans_spawned():
	return num_humans_spawned

# Function to get the number of spawned skeletons
func get_num_skeletons_spawned():
	return num_skeletons_spawned
