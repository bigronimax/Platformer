extends Node2D

@onready var start_in = %StartIn
@onready var start_in_label = $CanvasLayer/StartIn/StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel

var level_time = 0.0
var start_level_msec = 0.0

func _ready():
	#if not next_level is PackedScene:
		#next_level = load("res://Scenes/start_menu.tscn")
	
	PlatformerEvents.level_completed.connect(go_to_next_level)
	#get_tree().paused = true
	#start_in.visible = true
	#FadeTransition.fade_from_black()
	#animation_player.play("countdown")
	#await animation_player.animation_finished
	#get_tree().paused = false
	#start_in.visible = false
	#start_level_msec = Time.get_ticks_msec()
	
	
#func _process(delta):
	#level_time = Time.get_ticks_msec() - start_level_msec
	#level_time_label.text = str(level_time / 1000.0)
	
func go_to_next_level():
	#if not next_level is PackedScene: return
	#await FadeTransition.fade_to_black()
	#get_tree().paused = false
	#get_tree().change_scene_to_packed(next_level)
	SceneManager.transition_to(load("res://Scenes/satoru_fight.tscn"))
	

