# TrainingDummy.gd
extends StaticBody2D

@export var souls_per_click: int = 1
@export var clicks_per_second: float = 2.0

@onready var animated_sprite = $TrainingDummySprite
@onready var click_area = $ClickArea
@onready var soul_sprite = $SoulInterface/SoulGUI

var can_click: bool = true
var click_timer: Timer

func _ready():
	animated_sprite.play("Idle")
	soul_sprite.visible = false
	click_timer = Timer.new()
	click_timer.wait_time = 1.0 / clicks_per_second
	click_timer.one_shot = true
	click_timer.connect("timeout", _on_click_timer_timeout)
	add_child(click_timer)

func _on_ClickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and can_click:
			_on_click_training_dummy()
			can_click = false
			click_timer.start()

func _on_click_training_dummy():
	Global.set_soul_coins(Global.get_soul_coins() + souls_per_click)
	_show_soul_sprite()

func _show_soul_sprite():
	soul_sprite.visible = true
	soul_sprite.modulate = Color.WHITE
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(soul_sprite, "modulate", Color.TRANSPARENT, 0.5)

func _on_click_area_mouse_entered():
	animated_sprite.play("Clicking")

func _on_click_area_mouse_exited():
	animated_sprite.play("Idle")

func _on_AnimatedSprite2D_animation_finished(anim_name):
	if anim_name == "Clicking":
		if animated_sprite.frame == animated_sprite.get_sprite_frames().get_frame_count("Clicking") - 1:
			animated_sprite.frame = 0
	elif anim_name == "Idle":
		if animated_sprite.frame == animated_sprite.get_sprite_frames().get_frame_count("Idle") - 1:
			animated_sprite.frame = 0

func _on_click_timer_timeout():
	can_click = true
