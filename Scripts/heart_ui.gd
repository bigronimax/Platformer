extends Panel

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

func update(whole : bool):
	if whole: 
		sprite_2d.frame = 0
	else: 
		sprite_2d.frame = 1
		animation_player.play("Damage")
		get_tree().paused = true 
		await animation_player.animation_finished
		hide()
		get_tree().paused = false
