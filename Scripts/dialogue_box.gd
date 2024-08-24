extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var text_box_container = $TextBoxContainer
@onready var h_box_container = $TextBoxContainer/MarginContainer/HBoxContainer
@onready var start = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label
@onready var ez_dialogue = $"../EzDialogue"

@onready var choice_button_scn = preload("res://Scenes/choice_button.tscn")
@onready var tween = get_tree().create_tween()

var choice_buttons: Array[Button] = []

var reading = false
var end = false
var battle = false


func _ready():
	hide_textbox()

func _process(delta):
	if reading:
		if Input.is_action_just_pressed("accept"):
			tween.kill()
			label.visible_ratio = 1.0
			visible_buttons()
			reading = false

func _on_choice_selected(choice_index: int):
	if end:
		clear_textbox()
		hide_textbox()
		InteractionManager.can_interact = true
		end = false
		if battle:
			SceneManager.transition_to(load("res://Scenes/satoru_fight.tscn"))
		else:
			TopDownEvents.dialogue_end.emit()
	else:
		ez_dialogue.next(choice_index)

func add_text(text : String):
	label.text = text
	display_text(text)

func add_choice(choice_text: String):
	var button_obj = choice_button_scn.instantiate()
	button_obj.choice_index = choice_buttons.size()
	button_obj.text = choice_text
	choice_buttons.push_back(button_obj)
	button_obj.choice_selected.connect(_on_choice_selected)
	h_box_container.add_child(button_obj)
	invisible_buttons()

func hide_textbox():
	text_box_container.hide()

func clear_textbox():
	start.text = ""
	label.text = ""
	for choice in choice_buttons:
		h_box_container.remove_child(choice)
	choice_buttons = []

func show_textbox():
	start.text = "*"
	text_box_container.show()

func display_text(text : String):
	tween = get_tree().create_tween()
	show_textbox()
	reading = true
	tween.tween_property(label, "visible_characters", len(text), len(text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	visible_buttons()
	reading = false

func visible_buttons():
	for choice in choice_buttons:
		choice.visible = true
	choice_buttons[0].grab_focus()

func invisible_buttons():
	for choice in choice_buttons:
		choice.visible = false

func _on_ez_dialogue_end_of_dialogue_reached():
	end = true

func _on_ez_dialogue_custom_signal_received(value):
	if value == "battle":
		battle = true
