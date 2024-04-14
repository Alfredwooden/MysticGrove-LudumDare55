# World.gd
extends Node2D

@onready var heartContainer = $UI/Control/MarginContainer/Hearths/HeartsContainer
@onready var player = $Isometric_Village/Player

const camera_position_1_x = 191
const camera_position_1_y = 97

const camera_position_2_x = -178
const camera_position_2_y = 97

func _ready():
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)	
	player.healthChanged.connect(heartContainer.updateHearts)
	Global.enemy_spawn_point = $Isometric_Village/Spawns/HumanSpawnPoint
	Global.summon_spawn_point = $Isometric_Village/Spawns/SummonSpawnPoint


func _physics_process(delta):
	$UI/Control/MarginContainer/Souls/SoulsContainer/Souls_GUI/SoulsLabel.text  = "= " + str(Global.get_soul_coins())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Skulls_GUI/SkullLabel.text  = "= " + str(Global.get_skull_souls())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Ghosts_GUI/GhostLabel.text  = "= " + str(Global.get_ghost_souls())
