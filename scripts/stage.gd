extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")
var water_ball = preload("res://scenes/WaterBall.tscn")

func _ready():
	$CanvasLayer/ManaBar.get("custom_styles/fg").bg_color = ColorN("royalblue")




func _on_Player_stat_changed(hp, mana, shield_power):
	$CanvasLayer/HealthBar.value = hp
	$CanvasLayer/ManaBar.value = mana
	$CanvasLayer/ShieldBg/Shield.text = str(shield_power)
	
	if hp <= 30:
		$CanvasLayer/HealthBar.get("custom_styles/fg").bg_color = ColorN("red")
	else:
		$CanvasLayer/HealthBar.get("custom_styles/fg").bg_color = ColorN("webgreen")



func _on_Player_skill_cd(ball, shield):
	
	$CanvasLayer/ShieldSkillBg/ShieldSkill.value = shield
	$CanvasLayer/WaterBallSkillBg/WaterBallSkill.value = ball
