extends Node2D

const camera_position_1_x = 191
const camera_position_1_y = 97

const camera_position_2_x = -178
const camera_position_2_y = 97

func _ready():
	$Area_2/ColorRect.rect_size.x = 50


func _physics_process(delta):
	$Area_1/Skulls/SkullText.text = ("= " + str(Global.num_of_skulls))
	$Area_1/Ghosts/GhostText.text = ("= " + str(Global.num_of_ghosts))
	
	$Area_1/SoulCoins/SoulText.text = ("= " + str(Global.soul_coins))
	
	if Global.camera_pos == 1:
		$Camera2D.position.x = camera_position_1_x
		$Camera2D.position.y = camera_position_1_y
	elif Global.camera_pos == 2:
		$Camera2D.position.x = camera_position_2_x
		$Camera2D.position.y = camera_position_2_y


func _on_openFarmingZone2_body_entered(body):
	if body.has_method("player"):
		if $Area_2/openFarmingZone2/CollisionShape2D.disabled == false:
			Global.camera_pos = 2
			$Area_2/AnimationPlayer.play("SpawnField")
			$Area_2/openFarmingZone2/CollisionShape2D.disabled = true
