extends StaticBody2D

# Item 1 = Skull
# Item 2 = Random

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
	if self.visible == true:
		if item == 1:
			$SoulsBagsIcon.play("Skull")
			$PriceLabel.text = "100"
			if Global.soul_coins >= item_1_price:
				if item_1_owned == false:
					$BuyButtonColor.color = "6cb820" #green
				else:
					$BuyButtonColor.color = "eb9191" #red
			else:
				$BuyButtonColor.color = "eb9191" #red
		elif item == 2:
			$SoulsBagsIcon.play("Ghost")
			$PriceLabel.text = "250"
			if Global.soul_coins >= item_2_price:
				if item_2_owned == false:
					$BuyButtonColor.color = "6cb820" #green
				else:
					$BuyButtonColor.color = "eb9191" #red
			else:
				$BuyButtonColor.color = "eb9191" #red

func _on_LeftButton_pressed():
	swap_item_back()
func _on_RightButton_pressed():
	swap_item_forward()
func _on_BuyButton_pressed():
	if item == 1:
		price = item_1_price
		if Global.soul_coins >= price:
			if item_1_owned == false:
				buy()
	elif item == 2:
		price = item_2_price
		if Global.soul_coins >= price:
			if item_1_owned == false:
				buy() 
		

func swap_item_back():
	if item == 1:
		item = 2
	elif item == 2:
		item = 1

func swap_item_forward():
		if item == 1:
			item = 2
		elif item == 2:
			item = 1


func buy():
	Global.soul_coins -= price
	if item == 1:
		item_1_owned = true	
	if item == 2:
		item_2_owned = true
	
