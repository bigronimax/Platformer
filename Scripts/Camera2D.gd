extends Camera2D

@onready var cameraShakeNoise = FastNoiseLite.new()

func shake():
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(start_camera_shake, 5.0, 1.0, 0.5)

func start_camera_shake(intensity : float):
	var cameraOffset = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	offset.x = cameraOffset
	offset.y = cameraOffset


