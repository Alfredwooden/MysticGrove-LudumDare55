extends StaticBody2D

@onready var shopMenu = $External/ShopMenu
@onready var skullSoulpack = $External/Skull_soulpack
@onready var ghostSoulpack = $External/Ghost_soulpack

func _ready():
	$AnimatedSprite2D.play("defaul")
	$Seller_Sprite.play("default")
	shopMenu.visible = false

func _process(delta):
	if shopMenu.item_1_owned == true:
		skullSoulpack.visible = true
	if shopMenu.item_2_owned == true:
		ghostSoulpack.visible = true

func _on_Area2D_body_entered(body):
	if body.has_method("player_shop_method"):
		shopMenu.visible = true
		
func _on_Area2D_body_exited(body):
	shopMenu.visible = false
