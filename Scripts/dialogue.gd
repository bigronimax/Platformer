extends Node2D

@onready var state = {}

@onready var dialogue_box = $DialogueBox
@onready var ez_dialogue = $EzDialogue

func start_dialogue(dialogue_json):
	ez_dialogue.start_dialogue(dialogue_json, state)

func _on_ez_dialogue_dialogue_generated(response : DialogueResponse):
	TopDownEvents.dialogue_start.emit()
	dialogue_box.clear_textbox()
	dialogue_box.add_text(response.text)
	
	if response.choices.is_empty():
		dialogue_box.add_choice(">")
	
	for choice in response.choices:
		dialogue_box.add_choice(choice)
	
	if (dialogue_box.label.text == ""):
		dialogue_box.label.hide()
		for child in dialogue_box.h_box_container.get_children():
			if child.get_class() == "Button":
				child.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
				child.size_flags_vertical = Control.SIZE_SHRINK_CENTER
				child.size_flags_horizontal = Control.SIZE_EXPAND
	else:
		dialogue_box.label.show()


