# Summoning_Zone.gd
extends StaticBody2D

var soul = Global.get_soul_selected()
var soul_growing = false
var soul_grown = false

func _ready():
	$Summoning_circle.play("default")
	if not soul_growing:
		$Soul/SoulArrow.play("default")

func _physics_process(delta):
	if not soul_growing:
		soul = Global.get_soul_selected()
		$Soul/SoulArrow.play("default")

func _on_Area2D_area_entered(area):
	if not soul_growing:
		if soul == 1:
			soul_growing = true
			$Skull_Timer.start()
			$Soul.play("Skulls_growing")
			print("Skull growing")
		elif soul == 2:
			soul_growing = true
			$Ghost_Timer.start()
			$Soul.play("Ghosts_growing")
			print("Ghost growing")
	else:
		print("Soul is already being summoned")

func _on_Skull_Timer_timeout():
	var skull_soul = $Soul
	if skull_soul.frame == 0:
		print("Skull frame 1")
		skull_soul.frame = 1
		$Skull_Timer.start()
	elif skull_soul.frame == 1:
		print("Skull frame 2")
		skull_soul.frame = 2
	elif skull_soul.frame == 2:
		print("Skull frame 3")
		skull_soul.frame = 3
		soul_grown = true

func _on_Ghost_Timer_timeout():
	var ghost_soul = $Soul
	if ghost_soul.frame == 0:
		ghost_soul.frame = 1
		$Ghost_Timer.start()
	elif ghost_soul.frame == 1:
		ghost_soul.frame = 2
	elif ghost_soul.frame == 2:
		ghost_soul.frame = 3
		soul_grown = true

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		if soul_grown:
			if soul == 1:
				Global.set_skull_souls(Global.get_skull_souls() + 1)
				soul_growing = false
				soul_grown = false
				$Soul.play("None")
			elif soul == 2:
				Global.set_ghost_souls(Global.get_ghost_souls() + 1)
				soul_growing = false
				soul_grown = false
				$Soul.play("None")
			print("Number of Skulls => " + str(Global.get_skull_souls()))
			print("Number of Ghosts => " + str(Global.get_ghost_souls()))
			print("Number of Souls => " + str(Global.get_soul_coins()))
