# World.gd
extends Node2D

@onready var heartContainer = $UI/Control/MarginContainer/Hearths/HeartsContainer
@onready var player = $Isometric_Village/Player
@onready var day_icon = $UI/Control/MarginContainer/DayAndNight/DayContainer/Panel/Day
@onready var moon_icon = $UI/Control/MarginContainer/DayAndNight/DayContainer/Panel/Night
@onready var day_label = $UI/Control/MarginContainer/DayAndNight/DayContainer/Panel/DayLabel

###### SPAWNS #########
@onready var humans_spawn_node = $Isometric_Village/Spawns/Humans
@onready var skeletons_spawn_node = $Isometric_Village/Spawns/Skeletons
###### SPAWNS #########

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
	
	#spawn_human(5)  # Spawn 5 humans
	#spawn_skeleton(3)  # Spawn 3 skeletons


func _physics_process(delta):
	$UI/Control/MarginContainer/Souls/SoulsContainer/Souls_GUI/SoulsLabel.text = "= " + str(Global.get_soul_coins())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Skulls_GUI/SkullLabel.text = "= " + str(Global.get_skull_souls())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Ghosts_GUI/GhostLabel.text = "= " + str(Global.get_ghost_souls())
	
	update_day_night_icons()

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
func spawn_human(num_humans: int):
	for _i in range(num_humans):
		var new_human = load("res://Scenes/Characters/Human.tscn").instantiate()
		humans_spawn_node.add_child(new_human)
		new_human.global_position = Global.enemy_spawn_point.global_position
	
	# Update the number of spawned humans
	Global.update_num_humans_spawned(num_humans)

func spawn_skeleton(num_skeletons: int):
	for _i in range(num_skeletons):
		var new_skeleton = load("res://Scenes/Characters/Skeleton.tscn").instantiate()
		skeletons_spawn_node.add_child(new_skeleton)
		new_skeleton.global_position = Global.summon_spawn_point.global_position
	
	# Update the number of spawned skeletons
	Global.update_num_skeletons_spawned(num_skeletons)

# Functions to despawn all humans and skeletons
func despawn_all_humans():
	for human in humans_spawn_node.get_children():
		human.queue_free()

func despawn_all_skeletons():
	for skeleton in skeletons_spawn_node.get_children():
		skeleton.queue_free()
