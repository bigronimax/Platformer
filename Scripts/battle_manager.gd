extends Node

signal hit_enemy
signal attack_pressed

var dialogue

var current_enemy_health: int
var max_enemy_health: int
var levels : Array[PackedScene]
var dialogues: Array[JSON]

var after_battle: bool = false
var finish_battle: bool = false

var scene_index: int
var dialogue_index: int = -1

var rng = RandomNumberGenerator.new()
	
func _ready():
	PlatformerEvents.level_completed.connect(finish_attack)
	attack_pressed.connect(go_to_level)

func set_default():
	after_battle = false
	finish_battle = false
	dialogue_index = -1

func ready_battle(enemy: BaseEnemy):
	if !after_battle:
		levels = enemy.levels
		dialogues = enemy.dialogues
		current_enemy_health = enemy.health
		max_enemy_health = enemy.health
		
func go_to_level():
	if !levels.is_empty():
		dialogue_index += 1
		scene_index = rng.randi_range(0, levels.size() - 1)
		SceneManager.transition_to(levels[scene_index])
	else:
		pass

func finish_attack():
	current_enemy_health -= 1
	levels.remove_at(scene_index)
	after_battle = true
	if current_enemy_health == 0:
		finish_battle = true
	
