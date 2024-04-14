# ShopMenu.gd
extends StaticBody2D

# Item 1 = Skull | Item 2 = Ghost
var item = 1

var item_1_price = 100
var item_2_price = 250

var item_1_owned = false
var item_2_owned = false

var price

func _ready():
	$SoulsBagsIcon.play("Skull")
	item = 1

func _physics_process(delta):
	if self.visible:
		if item == 1:
			$SoulsBagsIcon.play("Skull")
			$PriceLabel.text = str(item_1_price)
			if Global.get_soul_coins() >= item_1_price:
				$BuyButtonColor.color = "6cb820" if not item_1_owned else "eb9191"
			else:
				$BuyButtonColor.color = "eb9191"
		elif item == 2:
			$SoulsBagsIcon.play("Ghost")
			$PriceLabel.text = str(item_2_price)
			if Global.get_soul_coins() >= item_2_price:
				$BuyButtonColor.color = "6cb820" if not item_2_owned else "eb9191"
			else:
				$BuyButtonColor.color = "eb9191"

func _on_BuyButton_pressed():
	if item == 1:
		price = item_1_price
		if Global.get_soul_coins() >= price and not item_1_owned:
			buy()
	elif item == 2:
		price = item_2_price
		if Global.get_soul_coins() >= price and not item_2_owned:
			buy()

func swap_item_back():
	item = 2 if item == 1 else 1

func swap_item_forward():
	item = 2 if item == 1 else 1

func buy():
	Global.set_soul_coins(Global.get_soul_coins() - price)
	if item == 1:
		item_1_owned = true
	elif item == 2:
		item_2_owned = true

func _on_LeftButton_pressed():
	swap_item_back()
func _on_RightButton_pressed():
	swap_item_forward()
