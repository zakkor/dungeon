extends RigidBody2D

onready var sprite = get_node("AnimatedSprite")
onready var healthbar = get_node("TextureProgress")
onready var blood = get_node("Particles2D")
onready var retaliate_timer = get_node("RetaliateTimer")
onready var atk_timer = get_node("AttackTimer")
onready var cd_timer = get_node("CdTimer")

const SPEED = 30
var health = 100

func get_hit(location, damage):
	apply_impulse(Vector2(0, 0), Vector2(4, 4) * (get_global_pos() - location))
	var angle = Vector2(4, 4) * (get_global_pos() - location)
	var rad = atan2(angle.y, angle.x)
	var deg = rad * 180 / 3.14159 + 90
	health -= 30;
	if sprite.get_animation() != "atk":
		sprite.play("grunt")
	blood.set_param(blood.PARAM_DIRECTION, deg)
	blood.set_emitting(true)
	if retaliate_timer.get_time_left() == 0:
		retaliate_timer.start()
	pass

func _ready():
	set_process(true)
	set_gravity_scale(0)

	sprite.play("idle")
	pass

func move_towards(location):
	if health > 0:
		if sprite.get_animation() != "atk" and sprite.get_animation() != "grunt":
			sprite.play("walk")
		apply_impulse(Vector2(0, 0), Vector2(0.1, 0.1) * (location - get_global_pos()))
		if (location - get_global_pos()).x > 0:
			sprite.set_flip_h(true)
		else:
			sprite.set_flip_h(false)
	

func attack():
	if health > 0:
		if cd_timer.get_time_left() == 0:
			sprite.stop()
			sprite.play("atk")
			cd_timer.start()

func _process(delta):
	if health == 100:
		healthbar.hide()
	else:
		healthbar.show()
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
	if sprite.get_animation() == "atk":
		sprite.stop()
		sprite.play("idle")


func _on_RetaliateTimer_timeout():
	pass


func _on_AttackTimer_timeout():
	#print("enemy hit!")
	#sprite.stop()
	pass
