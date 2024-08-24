class_name PlayerMovementData
extends Resource

@export var gravity = 1500
@export var acceleration = 2000
@export var deacceleration = 2000
@export var friction = 2000
@export var current_friction = 2000
@export var max_horizontal_speed = 400
@export var max_fall_speed = 1000
@export var jump_height = -700
@export var double_jump_height = -400
@export var squash_speed = 0.1
@export var wall_jump_height = -500
@export var wall_jump_push = 400
@export var max_fall_speed_wall_slide = 100
@export var wall_slide_gravity = 100
@export var dash_speed = 1000
@export var dash_length = 0.2
@export var after_dash_time = 0.1
@export var double_jump = true
@export var dash_object: PackedScene
@export var foot_step: PackedScene
@export var dash: AudioStream
@export var jump: AudioStream
@export var wall_jump: AudioStream
@export var death: AudioStream


