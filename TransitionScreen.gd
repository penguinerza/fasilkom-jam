extends CanvasLayer

signal transitioned

#func _ready():
#	transitioned()
#
#func transitioned():
#	$AnimationPlayer.play("fade_to_black")
#
#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "fade_to_black":
#		emit_signal("transitioned")
#		$AnimationPlayer.play("fade_to_normal")

func fade_black():
	$AnimationPlayer.play("fade_to_black")
	
func fade_normal():
	$AnimationPlayer.play("fade_to_normal")
