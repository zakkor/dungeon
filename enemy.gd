extends RigidBody2D

onready var sprite = get_node("AnimatedSprite")
onready var healthbar = get_node("TextureProgress")
onready var blood = get_node("Particles2D")

const SPEED = 30
var health = 100

func get_hit(location, damage):
	apply_impulse(Vector2(0, 0), Vector2(4, 4) * (get_global_pos() - location))
	health -= 30;
	sprite.play("grunt")
	blood.set_emitting(true)
	pass

func _ready():
	set_process(true)
	set_gravity_scale(0)
	sprite.play("idle")
	pass

func _process(delta):
	#die 
	healthbar.set_value(health)
	if health <= 0:
		set_layer_mask(2) 
		set_collision_mask(2) # not interactable
		sprite.play("die")
		set_process(false)
		healthbar.hide()


func _on_AnimatedSprite_finished():
	if sprite.get_animation() == "grunt":
		sprite.stop()
		sprite.play("idle")
