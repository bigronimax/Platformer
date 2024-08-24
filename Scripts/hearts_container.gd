extends HBoxContainer

@onready var heart_ui_scn = preload("res://Scenes/heart_ui.tscn")

func set_max_hearts(max_health : int):
	for i in range(max_health):
		var heart_obj = heart_ui_scn.instantiate()
		add_child(heart_obj)

func update_hearts(current_health: int):
	var hearts = get_children()
	for i in range(current_health):
		hearts[i].update(true)
	
	if BattleManager.max_enemy_health > current_health:
		if BattleManager.max_enemy_health > current_health + 1:
			for i in range(current_health + 1, hearts.size()):
				hearts[i].hide()
		hearts[current_health].update(false)
