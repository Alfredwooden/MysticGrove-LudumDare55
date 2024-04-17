# Shop.gd
extends StaticBody2D

@onready var shopMenu = $External/ShopMenu
@onready var skullSoulpack = $External/Skull_soulpack
@onready var ghostSoulpack = $External/Ghost_soulpack
@onready var devilSoulpack = $External/Devil_soulpack
@onready var sellerSprite = $Seller_Sprite
@onready var shopSprite = $AnimatedSprite2D

func _ready():
	shopSprite.play("default")
	sellerSprite.play("default")
	shopMenu.visible = false

func _process(delta):
	if shopMenu.item_1_owned == true:
		skullSoulpack.visible = true
	if shopMenu.item_2_owned == true:
		ghostSoulpack.visible = true	
	if shopMenu.item_3_owned == true:
		devilSoulpack.visible = true

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		shopMenu.visible = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		shopMenu.visible = false
