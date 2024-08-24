extends CharacterBody2D

@export var movement_data : PlayerMovementData

var is_wall_sliding : bool = false # check if we're currently sliding
var touching_ground : bool = false # check if we're touching the ground
var touching_wall : bool = false # check if we're touching wall
var touching_ledge : bool = false # check if we're touching ledge
var is_jumping : bool = false # check are we currently jumping
var is_double_jumping : bool = false # check are we currently double jumping
var air_jump_pressed : bool = false # check if we've pressed jump just before we land
var coyote_time : bool = false #check if we can just JUST after we leave platform 
var can_double_jump : bool = false # check if we can double jump
var is_dashing : bool = false # check if we're dashing
var can_dash : bool = true # check if we can dash? 

var dash_direction : Vector2 # get the direction we'll dash in

var vSpeed = 0
var hSpeed = 0

var last_step = 0
var trail = false

var after_dash = false
var ground_delay = false
var spriteColor = "blue"

@onready var anim = $AnimatedSprite2D
@onready var shockwave_animation = $CanvasLayer/ShockwaveRect/Shockwave_animation
@onready var starting_position = global_position

@onready var ground_ray1 = $raycast_container/ground_ray1
@onready var ground_ray2 = $raycast_container/ground_ray2
@onready var right_ray = $raycast_container/right_ray
@onready var left_ray = $raycast_container/left_ray
@onready var right_ledge_ray = $raycast_container/right_ledge_ray
@onready var left_ledge_ray = $raycast_container/left_ledge_ray

@onready var dash_timer = $dash_timer 
@onready var dash_ground_delay = $dash_ground_delay
@onready var dash_particles = $dash_particles
@onready var after_dash_timer = $after_dash_timer

@onready var shockwave_rect = $CanvasLayer/ShockwaveRect
@onready var camera_2d = $Camera2D

func _ready():
	dash_timer.connect("timeout", dash_timer_timeout)
	dash_ground_delay.connect("timeout", dash_ground_delay_timeout)
	PlatformerEvents.level_completed.connect(shockwave_disabled)

func _physics_process(delta):
	#check if we're grounded
	check_ground_wall_logic()
	#check if we're moving/jumping/sliding etc
	handle_input(delta)
	#handle our particles
	handle_player_particles()
	#apply the phsyics once we're done with the previous steps
	do_physics(delta)
	
func handle_player_particles():
	if(velocity.x == 0):
		last_step = -1
	if(anim.animation == "Run"):
		if(anim.frame == 1 or anim.frame == 8):
			if(last_step != anim.frame):
				last_step = anim.frame
				var footstep = movement_data.foot_step.instantiate()
				footstep.emitting = true
				footstep.global_position = Vector2(global_position.x,global_position.y + 5)
				get_parent().add_child(footstep)
	

func get_direction_from_input():
	var move_dir = Vector2()
	
	move_dir.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
	move_dir = move_dir.normalized()
	
	#check if no movement is pressed further enough... then dash towards ur facing position
	if (move_dir == Vector2(0,0)):
		if(anim.flip_h):
			move_dir.x = -1
		else:
			move_dir.x = 1
			
	return move_dir * movement_data.dash_speed

func dash_timer_timeout():
	is_dashing = false

func dash_ground_delay_timeout():
	ground_delay = true

func check_ground_wall_logic():
	# check for coyote time ( have we just left platform?)
	if (touching_ground and !(ground_ray1.is_colliding() or ground_ray2.is_colliding())):
		touching_ground = false
		coyote_time = true
		await get_tree().create_timer(0.1).timeout # we pause here for 100 milliseoncds
		coyote_time = false
	#check the moment we touch ground for first time
	if(!touching_ground and (ground_ray1.is_colliding() or ground_ray2.is_colliding())
	or touching_ground and ground_delay):
		anim.scale = Vector2(1.2,0.8)
		ground_delay = false
		can_dash = true
	
	#Check if either wall collider is touching a wall, if we are touching wall is true else false
	touching_wall = right_ray.is_colliding() or left_ray.is_colliding()
	
	#Check if either ledge collider is touching a ledge, if we are touching ledge is true else false
	touching_ledge = right_ledge_ray.is_colliding() or left_ledge_ray.is_colliding()
	
	#Set if if we're touching ground or note
	touching_ground = ground_ray1.is_colliding() or ground_ray2.is_colliding() 
	if(touching_ground):
		is_jumping = false
		can_double_jump = true
		velocity.y = 0
		vSpeed = 0
	
	#lock of wall sliding here
	if(is_on_wall() and !touching_ground and vSpeed > 0 and touching_ledge):
		if((Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) or 
		abs(Input.get_joy_axis(0,0)) > 0.3):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	

func handle_input(delta):
	handle_dash(delta)
	handle_movement(delta)
	handle_jumping(delta)

func handle_dash(delta):
	if (Input.is_action_just_pressed("dash") and can_dash and !touching_wall):
		is_dashing = true
		can_dash = false
		spriteColor = "red"
		dash_direction = get_direction_from_input()
		dash_timer.start(movement_data.dash_length)
		camera_2d.shake()
		shockwave_animation.play("shockwave")
		AudioPlayer.play_sfx(movement_data.dash)
		if (touching_ground):
			dash_ground_delay.start(0.5)
		
	if(is_dashing):
		trail = true
		dash_particles.emitting = true
		
		#if(touching_ground):
			#is_dashing = false
		if(is_on_wall()):
			is_dashing = false
		pass
	else:
		dash_particles.emitting = false
		trail = false
		spriteColor = "blue"
	
func shockwave_disabled():
	shockwave_animation.play("RESET")

func handle_jumping(delta):
	if(coyote_time and Input.is_action_just_pressed("jump")):
		vSpeed = movement_data.jump_height
		is_jumping = true
		can_double_jump = true
		AudioPlayer.play_sfx(movement_data.jump)
	
	if(touching_ground):
		if((Input.is_action_just_pressed("jump") or air_jump_pressed) and !is_jumping):
			vSpeed = movement_data.jump_height
			is_jumping = true
			touching_ground = false
			anim.scale = Vector2(0.5,1.2)
			AudioPlayer.play_sfx(movement_data.jump)
	else:
		#Do variable jump logic
		if(vSpeed < 0 and !Input.is_action_pressed("jump") and !is_double_jumping):
			vSpeed = max(vSpeed, movement_data.jump_height / 2)
		if(can_double_jump and Input.is_action_just_pressed("jump") and !coyote_time and movement_data.double_jump and !touching_wall):
			vSpeed = movement_data.double_jump_height
			anim.play("DoubleJump")
			is_double_jumping = true
			can_double_jump = false
		#Do some animation logic on the jump
		if(!is_double_jumping and vSpeed <0):
			anim.play("Jump")
		elif(!is_double_jumping and vSpeed > 0):
			anim.play("Fall")
		elif(is_double_jumping and anim.frame == 3):
			is_double_jumping = false
			
		if(right_ray.is_colliding() and Input.is_action_just_pressed("jump")):
			vSpeed = movement_data.wall_jump_height
			hSpeed = -movement_data.wall_jump_push
			anim.flip_h = true
			can_double_jump = true
			AudioPlayer.play_sfx(movement_data.wall_jump)
		elif(left_ray.is_colliding() and Input.is_action_just_pressed("jump")):
			vSpeed = movement_data.wall_jump_height
			hSpeed = movement_data.wall_jump_push
			anim.flip_h = false
			can_double_jump = true
			AudioPlayer.play_sfx(movement_data.wall_jump)
			
		if(is_wall_sliding):
			anim.play("Slide")
			is_double_jumping = false # the reason for this is we might not finish double jumping
			
		#check if we're pressing jump just before we land on a platform
		if(Input.is_action_just_pressed("jump")):
			air_jump_pressed = true
			await get_tree().create_timer(0.1).timeout
			air_jump_pressed = false

func handle_movement(delta):
	if(is_on_wall()):
		hSpeed = 0
		velocity.x = 0
	#controller right/keyboard right
	if(Input.get_joy_axis(0,0) > 0.3 or Input.is_action_pressed("move_right")):
		if(hSpeed <-100):
			hSpeed += (movement_data.deacceleration * delta)
			if(touching_ground):
				anim.play("Turn")
		elif(hSpeed < movement_data.max_horizontal_speed):
			hSpeed += (movement_data.acceleration * delta)
			anim.flip_h = false
			if(touching_ground):
				anim.play("Run")
		else:
			if(touching_ground):
				anim.play("Run")
	elif(Input.get_joy_axis(0,0) < -0.3 or Input.is_action_pressed("move_left")):
		if(hSpeed > 100):
			hSpeed -= (movement_data.deacceleration * delta)
			if(touching_ground):
				anim.play("Turn")
		elif(hSpeed > -movement_data.max_horizontal_speed):
			hSpeed -= (movement_data.acceleration * delta)
			anim.flip_h = true
			if(touching_ground):
				anim.play("Run")
		else:
			if(touching_ground):
				anim.play("Run")
	else:
		if(touching_ground):
			anim.play("Idle")
			
		hSpeed -= min(abs(hSpeed), movement_data.current_friction * delta) * sign(hSpeed)
			

func do_physics(delta):
	if(is_on_ceiling()):
		velocity.y = 10
		vSpeed = 10
	
	if(!is_wall_sliding):
		vSpeed += (movement_data.gravity * delta) # apply gravity downwards
		vSpeed = min(vSpeed,movement_data.max_fall_speed) # limit how fast we can fall
	else:
		vSpeed += (movement_data.wall_slide_gravity * delta)
		vSpeed = min(vSpeed,movement_data.max_fall_speed_wall_slide)
	
	
	#update our motion vector
	velocity.y = vSpeed
	velocity.x = hSpeed
	
	#apply our motion vector to move and slide
	if (is_dashing):
		velocity = dash_direction
		move_and_slide()
		vSpeed = 0
		hSpeed = 0
	elif (after_dash and !is_dashing):
		vSpeed = 1
		move_and_slide()
	else:
		move_and_slide()
	
	#lerp out squash/squeeze scale
	apply_squash_squeeze()
	pass
	
func apply_squash_squeeze():
	anim.scale.x = lerpf(anim.scale.x,1,movement_data.squash_speed)
	anim.scale.y = lerpf(anim.scale.y,1,movement_data.squash_speed)

func _on_hazard_detector_area_entered(area):
	global_position = starting_position

func _on_trail_timer_timeout():
	if trail:
		var dash_node = movement_data.dash_object.instantiate()
		dash_node.texture = anim.get_sprite_frames().get_frame_texture(anim.animation, anim.get_frame())
		dash_node.global_position = global_position
		dash_node.flip_h = anim.flip_h
		get_parent().add_child(dash_node)
		
func _on_after_dash_timer_timeout():
	after_dash = false


func _on_dash_timer_timeout():
	after_dash = true
	after_dash_timer.start(movement_data.after_dash_time)

func change_shader_center():
	shockwave_rect.material.set_shader_parameter("Center", position)

