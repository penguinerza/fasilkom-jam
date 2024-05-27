extends CanvasLayer

onready var bg = $BG
onready var dev = $Name
onready var makara = $Makara
onready var assets = $Assets
onready var transition = $TransitionScreen

func _ready():
	yield(get_tree().create_timer(2.0), "timeout")
	transition.fade_black()
	dev.visible = false
	makara.visible = true
	transition.fade_normal()
	yield(get_tree().create_timer(2.0), "timeout")
	transition.fade_black()
	makara.visible = false
	assets.visible = true
	transition.fade_normal()
	yield(get_tree().create_timer(2.0), "timeout")
	transition.fade_black()
	bg.visible = false
	assets.visible = false
	transition.fade_normal()
	queue_free()
