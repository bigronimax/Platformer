extends Panel

@export var select_sfx: AudioStream

@export var talk_dialogue : JSON
@export var items_dialogue : JSON

@onready var attack = $MarginContainer/Actions/Attack
@onready var dialogue = $"../Dialogue"

func _ready():
	attack.grab_focus()
	TopDownEvents.dialogue_end.connect(actions_appear)
	TopDownEvents.dialogue_start.connect(actions_disappear)
	if BattleManager.finish_battle:
		actions_disappear()

func actions_disappear():
	hide()

func actions_appear():
	show()
	attack.grab_focus()
	
func _on_items_pressed():
	AudioPlayer.play_sfx(select_sfx)
	dialogue.start_dialogue(items_dialogue)

func _on_run_pressed():
	AudioPlayer.play_sfx(select_sfx)
	get_tree().quit()

func _on_attack_pressed():
	AudioPlayer.play_sfx(select_sfx)
	BattleManager.attack_pressed.emit()
	
func _on_talk_pressed():
	AudioPlayer.play_sfx(select_sfx)
	dialogue.start_dialogue(talk_dialogue)

