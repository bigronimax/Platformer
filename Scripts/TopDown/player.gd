class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var can_move = true

@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	state_machine.Initialize(self)
	TopDownEvents.dialogue_start.connect(MoveOff)
	TopDownEvents.dialogue_end.connect(MoveOn)

func _process(delta):
	if can_move:
		direction = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()
	else:
		direction = Vector2.ZERO
	
func _physics_process(delta):
	move_and_slide()

func MoveOn():
	can_move = true
func MoveOff():
	can_move = false
	
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ))
	var new_dir = DIR_4[ direction_id ]

	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	animated_sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	

func UpdateAnimations(state : String) -> void:
	animated_sprite_2d.play(state + "_" + anim_direction())
	pass
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
