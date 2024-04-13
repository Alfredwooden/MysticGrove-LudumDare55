extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body.has_method("player_sell_method"):
		var skulls = Global.num_of_skulls
		var ghosts = Global.num_of_ghosts
		
		var soul_coins = Global.soul_coins
		
		# Skulls = 1 coins / Ghosts = 5 coins
		
		soul_coins += skulls * 1
		soul_coins += ghosts * 5
		
		skulls = 0
		ghosts = 0
		
		Global.soul_coins = soul_coins
		Global.num_of_skulls = skulls
		Global.num_of_ghosts = ghosts
