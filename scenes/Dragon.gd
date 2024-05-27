extends KinematicBody2D

const BULLET = preload("res://scenes/DragonBullet.tscn")
var player_pos = Vector2(0,0)

func _ready():
	yield(get_tree().create_timer(1), "timeout") 
	shoot()

func shoot():
	var bullet = BULLET.instance()
	get_parent().add_child(bullet)
	bullet.position = $Sprite.global_position
	bullet.velocity = player_pos - bullet.position
	yield(get_tree().create_timer(1), "timeout")
	shoot()
	

func _on_Player_send_global_pos(pos):
	player_pos = pos
