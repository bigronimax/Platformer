class_name State_Walk extends State

@export var speed : float = 100.0

@onready var idle : State = $"../Idle"

# what happens when the player enters this State?
func Enter() -> void:
	player.UpdateAnimations("Walk")
	pass
	
# what happens when the player exits this State?
func Exit() -> void:
	pass

# What happens during _process update in this State?
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * speed 
	
	if player.SetDirection():
		player.UpdateAnimations("Walk")
		
	return null

# What happens during _physics_process update in this State?
func Physics( _delta: float ) -> State:
	return null

# What happens with input events in this State?
func HandleInput( _event: InputEvent ) -> State:
	return null
