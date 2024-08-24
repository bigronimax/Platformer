extends TextureRect

@export var after_battle_scene: PackedScene
@export var deathParticle: PackedScene
@export var death_sound: AudioStream
@export var hit_sound: AudioStream

@onready var camera_2d = $"../Camera2D"
@onready var enemy_animation = $EnemyAnimation
@onready var enemy = $"."

func _ready():
	if BattleManager.after_battle:
		get_tree().paused = true
		await get_tree().create_timer(0.5).timeout
		enemy_animation.play("Hit")
		await enemy_animation.animation_finished
		get_tree().paused = false
	if BattleManager.finish_battle:
		AudioPlayer.stop()
		enemy_animation.play("Death")
		await enemy_animation.animation_finished
		await get_tree().create_timer(1).timeout
		BattleManager.set_default()
		SceneManager.transition_to(after_battle_scene)

func hit():
	AudioPlayer.play_sfx(hit_sound)
	camera_2d.shake()

func death():
	AudioPlayer.play_sfx(death_sound)
	var particle = deathParticle.instantiate()
	particle.position.x = position.x + size.x / 2
	particle.position.y = position.y + size.y / 2
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	enemy.texture = null
