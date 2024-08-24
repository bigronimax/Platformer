extends AudioStreamPlayer2D

func _process(delta):
	if get_tree().get_first_node_in_group("player") != null:
		var player = get_tree().get_first_node_in_group("player")
		transform = player.transform
	else:
		position = Vector2(0, 0)

func play_music(music: AudioStream):
	if stream == music:
		return
	
	stream = music
	bus = "Music"
	play()

func play_sfx(stream: AudioStream):
	var instance = AudioStreamPlayer2D.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.bus = "SFX"
	instance.play()

func remove_node(instance: AudioStreamPlayer2D):
	instance.queue_free()
