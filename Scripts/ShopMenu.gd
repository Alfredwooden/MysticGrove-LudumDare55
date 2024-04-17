# ShopMenu.gd
extends CanvasLayer

@onready var soulBags = $TextureRect/MarginContainer/Control/SoulsBagsIcon
@onready var priceLabel = $TextureRect/MarginContainer/Control/Price/PriceLabel
@onready var buyButtonIcon = $TextureRect/MarginContainer/Control/MarginContainer/BuyButton/BuyButtonIcon

var item = 1
var item_1_price = 100
var item_2_price = 250
var item_3_price = 500  # Price for the devil soul bag

var item_1_owned = false
var item_2_owned = false
var item_3_owned = false

func _ready():
	soulBags.play("Skull")
	item = 1

func _physics_process(delta):
	if self.visible:
		update_shop_display()

func update_shop_display():
	var price
	var item_owned

	if item == 1:
		price = item_1_price
		item_owned = item_1_owned
		soulBags.play("Skull")
	elif item == 2:
		price = item_2_price
		item_owned = item_2_owned
		soulBags.play("Ghost")
	else:
		price = item_3_price
		item_owned = item_3_owned
		soulBags.play("Devil")  # Play the devil soul bag animation

	priceLabel.text = "$" + str(price)

	if Global.get_soul_coins() >= price and not item_owned:
		buyButtonIcon.frame = 0 # Can buy
	else:
		buyButtonIcon.frame = 1 # Cannot buy

func _on_BuyButton_pressed():
	var price
	var item_owned

	if item == 1:
		price = item_1_price
		item_owned = item_1_owned
	elif item == 2:
		price = item_2_price
		item_owned = item_2_owned
	else:
		price = item_3_price
		item_owned = item_3_owned

	if Global.get_soul_coins() >= price and not item_owned:
		buy()

func swap_item():
	item = (item % 3) + 1  # Cycle through items 1, 2, and 3
	update_shop_display()

func buy():
	var price

	if item == 1:
		price = item_1_price
		item_1_owned = true
	elif item == 2:
		price = item_2_price
		item_2_owned = true
	else:
		price = item_3_price
		item_3_owned = true

	Global.set_soul_coins(Global.get_soul_coins() - price)
	update_shop_display()

func _on_LeftButton_pressed():
	swap_item()

func _on_RightButton_pressed():
	swap_item()
