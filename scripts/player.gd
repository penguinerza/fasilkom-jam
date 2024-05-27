extends KinematicBody2D



export (int) var speed = 200

const BULLET = preload("res://scenes/Bullet.tscn")

var velocity = Vector2()
var move_speed = 1
const MAX_HP = 100
export (int)var hp = 100
const MAX_MANA = 100
export (int)var mana = 100
var base_regen_per_sec = .1
var regen_mult = 1
var is_cast_skill = false
var is_auto_attack = false
var is_auto_paused = false
var is_have_shield = false
var shield_power = 0
var is_readies_shield = false
var is_readies_water_ball = false
onready var shield_cd = $ShieldTimer
onready var water_ball_cd = $WaterBallTimer

signal stat_changed(hp, mana, shield_power)
signal skill_cd(water_ball, shield)
signal send_global_pos(pos)

func _ready():
	regen()

func _process(_delta):
	if mana < 10:
		is_readies_water_ball = false
	if mana < 20:
		is_readies_shield = false
	emit_signal("skill_cd", water_ball_cd.time_left, shield_cd.time_left)
	emit_signal("send_global_pos", global_position)

func get_input():
	
	if Input.is_action_just_pressed("ball"):
		if mana >= 10 && water_ball_cd.is_stopped():
			is_readies_water_ball = true
		
	
	
	if !is_cast_skill:
		
		if is_readies_water_ball && Input.is_action_just_released("lmb"):
			cast_water_ball(get_global_mouse_position())
		
		if Input.is_action_just_pressed("shield"):
			if mana >= 20 && shield_cd.is_stopped():
				cast_shield()
			
		if Input.is_action_pressed("rmb"):
			is_auto_attack = false
			regen_mult = 10
		else:
			regen_mult = 1
		
		if Input.is_action_just_pressed("lmb"):
			is_auto_attack = !is_auto_attack
			if is_auto_attack:
				auto_attack()
	
	if Input.is_action_pressed("shift"):
		move_speed = 2
	else:
		move_speed = 1
	
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed * move_speed

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

func regen():
	hp += base_regen_per_sec * 0.25
	mana += base_regen_per_sec * regen_mult
	if hp > MAX_HP:
		hp = MAX_HP
	if mana > MAX_MANA:
		mana = MAX_MANA
	emit_signal("stat_changed", hp, mana, shield_power)
	yield(get_tree().create_timer(0.1), "timeout")
	regen()

func auto_attack():
	if !is_auto_paused:
		if mana > 1:
			mana -= 1
			var bullet = BULLET.instance()
			get_parent().add_child(bullet)
			bullet.position = $Grimoire.global_position
			bullet.velocity = get_global_mouse_position() - bullet.position
	yield(get_tree().create_timer(0.5), "timeout")
	if is_auto_attack:
		auto_attack()


func cast_water_ball(_target):
	is_auto_paused = true
	yield(get_tree().create_timer(2), "timeout")
	mana -= 10
	is_auto_paused = false

func cast_shield():
	is_auto_paused = true
	yield(get_tree().create_timer(2), "timeout")
	$ShieldArea/ShieldSprite.visible = true
	$ShieldArea/ShieldCollider.disabled = false
	is_have_shield = true
	is_auto_paused = false
	mana -= 20
	shield_power = 10
	shield_cd.start()
	emit_signal("stat_changed", hp, mana, shield_power)
