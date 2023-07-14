extends CharacterBody2D

@export var speed = 200
@export var acceleration = 400
@export var friction = 500


var velocity = Vector2.ZERO
var state = MOVEMENT
var dodge_vector = Vector2.DOWN
@export var dodge_speed = 250

enum {
	MOVEMENT,
	DODGE
}


#export var speed = 40.0
func _process(delta):
	match state:
		MOVEMENT:
			state_move(delta)
		DODGE:
			state_dodge(delta)
			
			
func state_move(delta):
	var vector = Vector2.ZERO
	vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	vector = vector.normalized()
	
	get_node("AnimatedSprite").animation = "attack"
	get_node("AnimatedSprite").play()
	
	if vector != Vector2.ZERO:
		dodge_vector = vector 
		get_node("AnimatedSprite").flip_h = vector.x < 0
		velocity = velocity.move_toward(vector * speed, acceleration * delta)
		velocity += vector * acceleration * delta
		velocity = velocity.clamped(speed) 
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move()
	
	if Input.is_action_just_pressed("dodge"):
		state = DODGE
	
func state_dodge(delta):
	get_node("AnimatedSprite").animation = "dodge"
	get_node("AnimatedSprite").play()
	
	velocity = dodge_vector * dodge_speed
	move()
	

func move():
	velocity = move_and_slide(velocity)
	

func _on_AnimatedSprite_animation_finished():
	state = MOVEMENT
