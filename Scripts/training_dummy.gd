extends StaticBody2D

@export var souls_per_click: int = 1
@export var clicks_per_second: float = 2.0

@onready var animated_sprite = $TrainingDummySprite
@onready var click_area = $ClickArea
@onready var soul_spawn_position = $SoulInterface
@onready var soul_container = $SoulInterface
@onready var effects = $Effects

var can_click: bool = true
var click_timer: Timer
var soul_scene = preload("res://Scenes/UI/More_Souls_GUI.tscn")

func _ready():
	animated_sprite.play("Idle")
	click_timer = Timer.new()
	click_timer.wait_time = 0.5 / clicks_per_second
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
	_spawn_soul_icon()
	effects.play("HurtBlink")
	await effects.animation_finished
	effects.play("RESET")

func _spawn_soul_icon():
	var soul_icon = soul_scene.instantiate()
	soul_container.add_child(soul_icon)
	soul_icon.global_position = soul_spawn_position.global_position

	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(soul_icon, "global_position", soul_icon.global_position + Vector2(0, -5), 0.2)
	tween.tween_callback(soul_icon.queue_free)

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
