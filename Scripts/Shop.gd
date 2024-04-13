extends StaticBody2D

func _ready():
	$ShopMenu.visible = false

func _process(delta):
	if $ShopMenu.item_1_owned == true:
		$Skull_soulpack.visible = true
	if $ShopMenu.item_2_owned == true:
		$Ghost_soulpack.visible = true

func _on_Area2D_body_entered(body):
	if body.has_method("player_shop_method"):
		$ShopMenu.visible = true
		
func _on_Area2D_body_exited(body):
	$ShopMenu.visible = false
