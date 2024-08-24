extends CharacterBody2D

@export var dialogue_json : JSON

@onready var interaction_area = $InteractionArea
@onready var dialogue = $Dialogue

func _ready():
	interaction_area.interact = Callable(self, "_on_interect")
	
func _on_interect():
	dialogue.start_dialogue(dialogue_json)
