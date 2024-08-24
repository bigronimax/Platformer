extends CanvasLayer

signal transitioned_in()
signal transitioned_out()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition_in() -> void:
	animation_player.play("In")


func transition_out() -> void:
	animation_player.play("Out")


func transition_to(scene: PackedScene) -> void:
	get_tree().paused = true
	transition_in()
	await transitioned_in

	get_tree().change_scene_to_packed(scene)

	transition_out()
	await transitioned_out
	get_tree().paused = false

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "In":
		transitioned_in.emit()
	elif anim_name == "Out":
		transitioned_out.emit()
