extends CenterContainer

@onready var start_game_button = %StartGameButton
@onready var quit_button = %QuitButton
@onready var menu = $Menu
@onready var settings = $Settings
@onready var back_button = $Settings/VBoxContainer/BackButton

@export var select_sfx: AudioStream
@export var next_scene: PackedScene
@export var music: AudioStream

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioPlayer.play_music(music)
	RenderingServer.set_default_clear_color(Color.BLACK)
	start_game_button.grab_focus()
	FadeTransition.fade_from_black()

func _on_start_game_button_pressed():
	AudioPlayer.play_sfx(select_sfx)
	quit_button.disabled = true
	await FadeTransition.fade_to_black()
	get_tree().change_scene_to_packed(next_scene)
	

func _on_settings_button_pressed():
	AudioPlayer.play_sfx(select_sfx)
	show_and_hide(settings, menu)
	back_button.grab_focus()

func _on_quit_button_pressed():
	AudioPlayer.play_sfx(select_sfx)
	start_game_button.disabled = true
	get_tree().quit()

func _on_back_button_pressed():
	AudioPlayer.play_sfx(select_sfx)
	show_and_hide(menu, settings)
	start_game_button.grab_focus()

func show_and_hide(first, second):
	first.show()
	second.hide()
