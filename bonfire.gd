extends Node2D

onready var light = get_node("Light2D")
onready var anim_spr = get_node("AnimSprite")
onready var static_spr = get_node("StaticSprite")
onready var area = get_node("InteractArea")
onready var label = get_node("HUD/CenterContainer/InteractLabel")

func _process(delta):
	if anim_spr.is_visible():
		label.set_text("Press E to rest")
	else:
		label.set_text("Press E to light bonfire")
	
	if player_in_range():
		label.show()
	else:
		label.hide()

func player_in_range():
	var bodies = area.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("player"):
			return true
	return false

func try_interaction():
	var bodies = area.get_overlapping_bodies()

	for b in bodies:
		if b.is_in_group("player"):
			print("found player")
			b.last_bonfire = self
			
			if !anim_spr.is_visible():
				anim_spr.show()
				static_spr.hide()
				light.show()
			else:
				activate(b)

func activate(player):
	print("gave health and resetted")
	# give player health and revive all enemies
	player.health = 100
	
	get_parent().get_parent().reset_enemies()

func _ready():
	set_process(true)

# flicker
func _on_Timer_timeout():
	var energy = randf()*0.7+0.7
	light.set_energy(energy)
