# ShopMenu.gd
extends CanvasLayer

@onready var soulBags = $TextureRect/Control/SoulsBagsIcon
@onready var priceLabel = $TextureRect/Control/Price/PriceLabel
@onready var buyButtonIcon = $TextureRect/Control/MarginContainer/BuyButton/BuyButtonIcon

var item = 1
var item_1_price = 100
var item_2_price = 250
var item_1_owned = false
var item_2_owned = false

func _ready():
	soulBags.play("Skull")
	item = 1

func _physics_process(delta):
	if self.visible:
		update_shop_display()

func update_shop_display():
	var price = item_1_price if item == 1 else item_2_price
	var item_owned = item_1_owned if item == 1 else item_2_owned
	soulBags.play("Skull" if item == 1 else "Ghost")
	priceLabel.text = "$" + str(price)

	if Global.get_soul_coins() >= price and not item_owned:
		buyButtonIcon.frame = 0  # Can buy
	else:
		buyButtonIcon.frame = 1  # Cannot buy


func _on_BuyButton_pressed():
	var price = item_1_price if item == 1 else item_2_price
	var item_owned = item_1_owned if item == 1 else item_2_owned

	if Global.get_soul_coins() >= price and not item_owned:
		buy()

func swap_item():
	item = 2 if item == 1 else 1
	update_shop_display()

func buy():
	var price = item_1_price if item == 1 else item_2_price
	Global.set_soul_coins(Global.get_soul_coins() - price)
	if item == 1:
		item_1_owned = true
	else:
		item_2_owned = true
	update_shop_display()

func _on_LeftButton_pressed():
	swap_item()
func _on_RightButton_pressed():
	swap_item()
