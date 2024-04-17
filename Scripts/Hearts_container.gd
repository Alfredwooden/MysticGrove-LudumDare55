extends HBoxContainer

@onready var HeartGuiClass = preload("res://Scenes/UI/hearth_gui.tscn")

func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	
	# Update the existing hearts
	for i in range(hearts.size()):
		if i < currentHealth:
			if i < hearts.size():
				hearts[i].update(true)
		else:
			if i < hearts.size():
				hearts[i].update(false)
