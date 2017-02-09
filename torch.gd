extends Node2D

onready var light = get_node("Light2D")
onready var anim_spr = get_node("AnimSprite")
onready var static_spr = get_node("StaticSprite")

func toggle():
	if !anim_spr.is_visible():
		anim_spr.show()
		static_spr.hide()
		light.show()
	else:
		anim_spr.hide()
		static_spr.show()
		light.hide()

func _ready():
	pass

# flicker
func _on_Timer_timeout():
	var energy = randf()*0.55+0.55
	light.set_energy(energy)	
	pass
