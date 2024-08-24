extends Node2D

@export var music: AudioStream

func _ready():
	AudioPlayer.play_music(music)
	get_tree().paused = true
	FadeTransition.fade_from_black()
	get_tree().paused = false
