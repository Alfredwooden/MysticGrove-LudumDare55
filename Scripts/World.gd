# World.gd
extends Node2D

@onready var heartContainer = $UI/Control/MarginContainer/Hearths/HeartsContainer
@onready var player = $Isometric_Village/Player
@onready var day_icon = $UI/Control/MarginContainer/DayAndNight/DayContainer/Panel/Day
@onready var moon_icon = $UI/Control/MarginContainer/DayAndNight/DayContainer/Panel/Night
@onready var day_label = $UI/Control/MarginContainer/DayAndNight/DayContainer/Panel/DayLabel

###### SPAWNS #########
@onready var humans_spawn_node = $Isometric_Village/Spawns/Humans
@onready var barbarians_spawn_node = $Isometric_Village/Spawns/Humans
@onready var angels_spawn_node = $Isometric_Village/Spawns/Humans
@onready var skeletons_spawn_node = $Isometric_Village/Spawns/Skeletons
@onready var ghosts_spawn_node = $Isometric_Village/Spawns/Skeletons
@onready var devils_spawn_node = $Isometric_Village/Spawns/Skeletons
###### SPAWNS #########

###### SummoningZones #########
var num_active_spawning_zones = 1
@onready var spawningZones = [
	$Isometric_Village/Summoning_Zones/Summoning_Zone, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone2, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone3, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone4, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone5, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone6, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone7, 
	$Isometric_Village/Summoning_Zones/Summoning_Zone8
]
###### SummoningZones #########

const camera_position_1_x = 191
const camera_position_1_y = 97
const camera_position_2_x = -178
const camera_position_2_y = 97

func _ready():
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartContainer.updateHearts)
	Global.enemy_spawn_point = $Isometric_Village/HumanSpawnPoint
	Global.summon_spawn_point = $Isometric_Village/SummonSpawnPoint

func _physics_process(delta):
	$UI/Control/MarginContainer/Souls/SoulsContainer/Souls_GUI/SoulsLabel.text = "= " + str(Global.get_soul_coins())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Skulls_GUI/SkullLabel.text = "= " + str(Global.get_skull_souls())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Ghosts_GUI/GhostLabel.text = "= " + str(Global.get_ghost_souls())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Devils_GUI/DevilLabel.text = "= " + str(Global.get_devil_souls())

	update_day_night_icons()
	update_active_spawning_zones()

func update_day_night_icons():
	var time_of_day = Global.get_time_of_day()
	if time_of_day == "day":
		day_icon.visible = true
		moon_icon.visible = false
		day_label.text = "Day " + str(Global.current_day)
	elif time_of_day == "night":
		day_icon.visible = false
		moon_icon.visible = true
		day_label.text = "Night " + str(Global.current_day)

# Functions to spawn humans and skeletons
func spawn_human():
	var num_humans = Global.current_day
	for _i in range(num_humans):
		var new_human = load("res://Scenes/Characters/Human.tscn").instantiate()
		humans_spawn_node.add_child(new_human)
		
		# Calculate a random offset for the spawn position
		var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		new_human.global_position = Global.enemy_spawn_point.global_position + random_offset
	
	Global.update_num_humans_spawned(num_humans)

func spawn_skeleton():
	var num_skeletons = min(Global.get_skull_souls(), spawningZones.size())
	for _i in range(num_skeletons):
		var new_skeleton = load("res://Scenes/Characters/Skeleton.tscn").instantiate()
		skeletons_spawn_node.add_child(new_skeleton)
		var active_zones = spawningZones.slice(0, num_active_spawning_zones - 1)
		if active_zones.size() > 0:
			var random_zone = active_zones[randi() % active_zones.size()]
			new_skeleton.global_position = random_zone.global_position
		else:
			# No active spawning zones available
			new_skeleton.global_position = Global.summon_spawn_point.global_position
		Global.update_num_skeletons_spawned(1)
		Global.set_skull_souls(Global.get_skull_souls() - 1)

func spawn_barbarian():
	var num_barbarians = Global.current_day / 2
	for _i in range(num_barbarians):
		var new_barbarian = load("res://Scenes/Characters/Barbarian.tscn").instantiate()
		barbarians_spawn_node.add_child(new_barbarian)
		var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		new_barbarian.global_position = Global.enemy_spawn_point.global_position + random_offset

func spawn_angel():
	var num_angels = Global.current_day / 3
	for _i in range(num_angels):
		var new_angel = load("res://Scenes/Characters/Angel.tscn").instantiate()
		angels_spawn_node.add_child(new_angel)
		var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		new_angel.global_position = Global.enemy_spawn_point.global_position + random_offset

func spawn_ghost():
	var num_ghosts = min(Global.get_ghost_souls(), spawningZones.size())
	for _i in range(num_ghosts):
		var new_ghost = load("res://Scenes/Characters/Ghost.tscn").instantiate()
		ghosts_spawn_node.add_child(new_ghost)
		var active_zones = spawningZones.slice(0, num_active_spawning_zones - 1)
		if active_zones.size() > 0:
			var random_zone = active_zones[randi() % active_zones.size()]
			new_ghost.global_position = random_zone.global_position
		else:
			new_ghost.global_position = Global.summon_spawn_point.global_position
		Global.set_ghost_souls(Global.get_ghost_souls() - 1)

func spawn_devil():
	var num_devils = min(Global.get_devil_souls(), spawningZones.size())
	for _i in range(num_devils):
		var new_devil = load("res://Scenes/Characters/Devil.tscn").instantiate()
		devils_spawn_node.add_child(new_devil)
		var active_zones = spawningZones.slice(0, num_active_spawning_zones - 1)
		if active_zones.size() > 0:
			var random_zone = active_zones[randi() % active_zones.size()]
			new_devil.global_position = random_zone.global_position
		else:
			# No active spawning zones available
			new_devil.global_position = Global.summon_spawn_point.global_position
		Global.set_devil_souls(Global.get_devil_souls() - 1)

func despawn_all_humans():
	for human in humans_spawn_node.get_children():
		human.queue_free()

func despawn_all_skeletons():
	for skeleton in skeletons_spawn_node.get_children():
		skeleton.queue_free()

func update_active_spawning_zones():
	num_active_spawning_zones = min(1 + (Global.current_day - 1) / 5, spawningZones.size())
	for i in range(spawningZones.size()):
		spawningZones[i].visible = i < num_active_spawning_zones
