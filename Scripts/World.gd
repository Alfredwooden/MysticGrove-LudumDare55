# World.gd
extends Node2D

@onready var heartContainer = $UI/Control/MarginContainer/Hearths/HeartsContainer
@onready var player = $Player

const camera_position_1_x = 191
const camera_position_1_y = 97

const camera_position_2_x = -178
const camera_position_2_y = 97

func _ready():
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)	
	player.healthChanged.connect(heartContainer.updateHearts)
	$Area_2/ColorRect.size.x = 50

func _physics_process(delta):
	$UI/Control/MarginContainer/Souls/SoulsContainer/Souls_GUI/SoulsLabel.text  = "= " + str(Global.get_soul_coins())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Skulls_GUI/SkullLabel.text  = "= " + str(Global.get_skull_souls())
	$UI/Control/MarginContainer/Souls/SoulsContainer/Ghosts_GUI/GhostLabel.text  = "= " + str(Global.get_ghost_souls())

	if Global.camera_pos == 1:
		$Camera2D.position.x = camera_position_1_x
		$Camera2D.position.y = camera_position_1_y
	elif Global.camera_pos == 2:
		$Camera2D.position.x = camera_position_2_x
		$Camera2D.position.y = camera_position_2_y

func _on_openFarmingZone2_body_entered(body):
	if body.has_method("player"):
		if not $Area_2/openFarmingZone2/CollisionShape2D.disabled:
			Global.camera_pos = 2
			$Area_2/AnimationPlayer.play("SpawnField")
			$Area_2/openFarmingZone2/CollisionShape2D.disabled = true
