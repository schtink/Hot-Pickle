extends RigidBody2D

var screen_size
var ball_position
var direction = Vector2()
onready var left_rect = get_node("../Left Player")
onready var right_rect = get_node("../Right Player")

export var speed = Vector2(5,0)
onready var ball = get_node("../Tomato")

func _ready():
	
	print(left_rect.position.x)
	print(right_rect.position.x)
	
	screen_size = get_viewport_rect().size
	
	if ((ball.position.y < 0 and direction.y < 0) or (ball.position.y > screen_size.y and direction.y > 0)):
			direction.y = -direction.y
	# Check gameover
	if (ball.position.x < 0 or ball.position.x > screen_size.x):
		ball.position = screen_size*0.5
	print("Ball is ", ball.position.x)
	
	# Flip, change direction and increase speed when touching pads
	if ((left_rect.position == ball.position and direction.x < 0) or (right_rect.position == ball.position and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		speed *= 1.1

func _physics_process(delta):
	apply_impulse(Vector2(direction.x,direction.y), Vector2(speed.x, speed.y))
