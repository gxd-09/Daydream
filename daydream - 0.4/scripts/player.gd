extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var remaining_jumps = 2

# Dash settings
const DASH_SPEED = 250.0
const DASH_TIME = 0.5     # how long dash lasts
const DASH_COOLDOWN = 0.5 # time before you can dash again

var death = false
var dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# Handle dash timers
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			dashing = false
			dash_cooldown_timer = DASH_COOLDOWN
	else:
		if dash_cooldown_timer > 0.0:
			dash_cooldown_timer -= delta
	
	var direction := Input.get_axis("A", "D")
		#animations


	
	if Input.is_action_just_pressed("Shift") and not dashing and dash_cooldown_timer <= 0.0:

		if direction != 0:  # only dash if pressing left/right
			dashing = true
			dash_timer = DASH_TIME
			velocity.x = direction * DASH_SPEED
			animated_sprite.play("dash")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		remaining_jumps = 2
	

	# Handle jump.
	if (Input.is_action_just_pressed("Space") or Input.is_action_just_pressed("W")):
		if remaining_jumps > 0:
			velocity.y = JUMP_VELOCITY
			remaining_jumps -= 1
		
	
			
		
	if death:
		animated_sprite.play("death")
	else:
		if dashing:
				animated_sprite.play("dash")
		elif is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	
	
	
	#flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	

		
	if not dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
