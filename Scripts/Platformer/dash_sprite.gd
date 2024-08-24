extends Sprite2D

func _physics_process(delta):
	modulate.a = lerpf(modulate.a, 0, 0.05)
	if (modulate.a < 0.1):
		queue_free()
