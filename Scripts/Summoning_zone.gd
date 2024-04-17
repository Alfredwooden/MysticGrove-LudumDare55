# Summoning_Zone.gd
extends StaticBody2D

@onready var soul_sprite = $SoulInterface/SoulGUI

var soul = Global.get_soul_selected()
var soul_growing = false
var soul_grown = false

func _ready():
	$Summoning_circle.play("Growing")
	soul_sprite.visible = false
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
			$Timers/Skull_Timer.start()
			$Soul.play("Skulls_growing")
			$Summoning_circle.play("Growing")
			$Soul/SoulArrow.play("Growing")
		elif soul == 2:
			soul_growing = true
			$Timers/Ghost_Timer.start()
			$Soul.play("Ghosts_growing")
			$Summoning_circle.play("Growing")
			$Soul/SoulArrow.play("Growing")
		elif soul == 3:  # Add devil soul condition
			soul_growing = true
			$Timers/Devil_Timer.start()
			$Soul.play("Devils_growing")
			$Summoning_circle.play("Growing")
			$Soul/SoulArrow.play("Growing")
		else:
			print("Soul is already being summoned")

func _on_Skull_Timer_timeout():
	var skull_soul = $Soul
	if skull_soul.frame == 0:
		print("Skull frame 1")
		skull_soul.frame = 1
		$Timers/Skull_Timer.start()
	elif skull_soul.frame == 1:
		print("Skull frame 2")
		skull_soul.frame = 2
	elif skull_soul.frame == 2:
		print("Skull frame 3")
		skull_soul.frame = 3
		soul_grown = true
		$Summoning_circle.stop()
		$Soul/SoulArrow.stop()

func _on_Ghost_Timer_timeout():
	var ghost_soul = $Soul
	if ghost_soul.frame == 0:
		ghost_soul.frame = 1
		$Timers/Ghost_Timer.start()
	elif ghost_soul.frame == 1:
		ghost_soul.frame = 2
	elif ghost_soul.frame == 2:
		ghost_soul.frame = 3
		soul_grown = true
		$Summoning_circle.stop()
		$Soul/SoulArrow.stop()

func _on_Devil_Timer_timeout():  # Add devil soul timer function
	var devil_soul = $Soul
	if devil_soul.frame == 0:
		devil_soul.frame = 1
		$Timers/Devil_Timer.start()
	elif devil_soul.frame == 1:
		devil_soul.frame = 2
	elif devil_soul.frame == 2:
		devil_soul.frame = 3
		soul_grown = true
		$Summoning_circle.stop()
		$Soul/SoulArrow.stop()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		if soul_grown:
			if soul == 1:
				Global.set_skull_souls(Global.get_skull_souls() + 1)
			elif soul == 2:
				Global.set_ghost_souls(Global.get_ghost_souls() + 1)
			elif soul == 3:  # Add devil soul condition
				Global.set_devil_souls(Global.get_devil_souls() + 1)
			soul_growing = false
			soul_grown = false
			$Summoning_circle.play("default")
			$Soul/SoulArrow.play("default")
			$Soul.play("None")
			_show_soul_sprite()

func _show_soul_sprite():
	soul_sprite.visible = true
	soul_sprite.modulate = Color.WHITE
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(soul_sprite, "modulate", Color.TRANSPARENT, 0.5)
