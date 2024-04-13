extends StaticBody2D

var soul = Global.soul_selected
var soul_growing = false
var soul_grown = false

func _physics_process(delta):
	if soul_growing == false:
		soul = Global.soul_selected


func _on_Area2D_area_entered(area):
	if not soul_growing: 
		if soul == 1:
			soul_growing = true
			$Skull_Timer.start()
			$Soul.play("Skulls_growing")
			print("Skull growing")
		if soul == 2:
			soul_growing = true
			$Ghost_Timer.start()
			$Soul.play("Ghosts_growing")
			$Soul.play()
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
				Global.num_of_skulls += 1
				soul_growing = false
				soul_grown = false
				$Soul.play("None")
			if soul == 2:
				Global.num_of_ghosts += 1
				soul_growing = false
				soul_grown = false
				$Soul.play("None")
			else: 
				pass

