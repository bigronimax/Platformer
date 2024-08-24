extends Control

@export var enemy : BaseEnemy
@export var music: AudioStream

@onready var healths_ui = $HeartsContainer
@onready var enemy_texture = $Enemy
@onready var dialogue = $Dialogue

func _ready():
	if BattleManager.after_battle:
		if BattleManager.dialogue_index < enemy.dialogues.size():
			dialogue.start_dialogue(BattleManager.dialogues[BattleManager.dialogue_index])
	AudioPlayer.play_music(music)
	enemy_texture.texture = enemy.texture 
	BattleManager.ready_battle(enemy)
	healths_ui.set_max_hearts(BattleManager.max_enemy_health)
	healths_ui.update_hearts(BattleManager.current_enemy_health)
	
	
	
	


	
	
	
