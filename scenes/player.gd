extends KinematicBody2D

var velocity = Vector2()
var speed = 300
var is_running = false
var did_double_jump = false
var is_crouching = false
var speed_multiplier = 1
var last_key = {}
var cd = .5
const GRAVITY = 5000

#signal status(is_running, did_double_jump, is_crouching)

# Implementasi animasi
func _process(_delta):
	if velocity.x > 0:
		pass
		#$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		pass
		#$AnimatedSprite.flip_h = true
			
	if !is_on_floor():
		if velocity.y > 0:
			pass
			#$AnimatedSprite.play("fall")
		else:
			pass
			#$AnimatedSprite.play("jump")
			
	else:
		did_double_jump = false
		if velocity.x != 0:
			pass
			#$AnimatedSprite.play("run")
		else:
			is_running = false
			#$AnimatedSprite.play("idle")
		
		if Input.is_action_pressed("down"):
			is_crouching = true
			#$AnimatedSprite.play("crouch")
		else:
			is_crouching = false
	
	#emit_signal("status", is_running, did_double_jump, is_crouching)

func jump():
	if !is_on_floor():
		if did_double_jump:
			return
		did_double_jump = true
	velocity.y = -1000

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("shift"):
		is_running = true
	if Input.is_action_just_released("shift"):
		is_running = false
	
	var vector = 0
	var now = OS.get_ticks_msec() / 1000.0
	if Input.is_action_pressed("right"):
		vector = 1
		if "right" in last_key:
			if now - last_key["right"] < 0.3:
				is_running = true
	elif Input.is_action_pressed("left"):
		vector = -1
		if "left" in last_key:
			if now - last_key["left"] < 0.3:
				is_running = true
	else:
		vector = 0
		
	if Input.is_action_just_released("right"):
		last_key["right"] = OS.get_ticks_msec() / 1000.0
	if Input.is_action_just_released("left"):
		last_key["left"] = OS.get_ticks_msec() / 1000.0

	# Implementasi crouching
	if Input.is_action_pressed("down") && is_on_floor():
		speed_multiplier = .3
	else:
		if is_running:
			speed_multiplier = 1.6
		else:
			speed_multiplier = 1
	
	# Implementasi jump (+double jump)
	if Input.is_action_just_pressed("up"):
		jump()
	
	velocity.x = speed * vector * speed_multiplier
	velocity = move_and_slide(velocity, Vector2.UP, true)

