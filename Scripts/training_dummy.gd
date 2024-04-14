# TrainingDummy.gd
extends Area2D

@export var soul_points_per_hit: int = 1

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.connect("hit_training_dummy", _on_player_hit)

func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.disconnect("hit_training_dummy", _on_player_hit)

func _on_player_hit():
	Global.set_soul_coins(Global.get_soul_coins() + soul_points_per_hit)
