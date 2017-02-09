extends RigidBody2D

onready var sprite = get_node("AnimatedSprite")

const SPEED = 30
var health = 100

func _ready():
	set_process(true)
	set_gravity_scale(0)
	sprite.play("idle")
	pass

func _process(delta):
	#die 
	if health <= 0:
		set_layer_mask(2) 
		set_collision_mask(2) # not interactable
		sprite.play("die")
		set_process(false)


func _on_AnimatedSprite_finished():
	if sprite.get_animation() == "grunt":
		sprite.stop()
		sprite.play("idle")
