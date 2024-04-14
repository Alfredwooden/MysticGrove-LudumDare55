extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body.has_method("player_sell_method"):
		# Retrieve the current counts
		var skulls = Global.get_skull_souls()
		var ghosts = Global.get_ghost_souls()
		
		# Calculate the new amount of soul coins
		var soul_coins = Global.get_soul_coins() + (skulls * 1) + (ghosts * 5)
		
		# Reset the counts of skulls and ghosts
		Global.set_skull_souls(0)
		Global.set_ghost_souls(0)
		
		# Update the soul coins
		Global.set_soul_coins(soul_coins)
