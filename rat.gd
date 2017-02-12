extends RigidBody2D

onready var sprite = get_node("AnimatedSprite")
onready var healthbar = get_node("TextureProgress")
onready var blood = get_node("BloodPart")
onready var retaliate_timer = get_node("RetaliateTimer")
onready var atk_timer = get_node("AttackTimer")
onready var cd_timer = get_node("CdTimer")
onready var hurtarea = get_node("HurtArea")
onready var lock = get_node("Lock")
onready var player = get_parent().get_tree().get_nodes_in_group("player")[0]

const DAMAGE = 50
var health = 100
var mouse_inside = false
var initial_pos

func get_hit(location):
	apply_impulse(Vector2(0, 0), Vector2(4, 4) * (get_global_pos() - location))
	var angle = Vector2(4, 4) * (get_global_pos() - location)
	var rad = atan2(angle.y, angle.x)
	var deg = rad * 180 / 3.14159 + 90
	health -= DAMAGE;
	if sprite.get_animation() != "atk":
		sprite.play("grunt")
	blood.set_param(blood.PARAM_DIRECTION, deg)
	blood.set_emitting(true)
	if retaliate_timer.get_time_left() == 0:
		retaliate_timer.start()
	pass

func _input(event):
	if mouse_inside and event.is_action_pressed("lock"):
		if lock.is_visible():
			lock.hide()
			player.lock_tracking = Vector2(-1, -1)
			return
		
		# hide the all of them
		for e in get_parent().get_tree().get_nodes_in_group("enemy"):
			e.lock.hide()
			player.lock_tracking = Vector2(-1, -1)
		
		if !lock.is_visible():
			lock.show()

func _ready():
	set_process(true)
	set_gravity_scale(0)
	set_process_input(true)
	sprite.play("idle")
	initial_pos = get_global_pos()


func move_towards(location):
	if health > 0:
		if sprite.get_animation() != "atk" and sprite.get_animation() != "grunt":
			sprite.play("walk")
			apply_impulse(Vector2(0, 0), Vector2(0.1, 0.1) * (location - get_global_pos()))
			if (location - get_global_pos()).x > 0:
				sprite.set_flip_h(true)
				hurtarea.get_node("CollisionPolygon2D").set_pos(Vector2(20, 0))
			else:
				sprite.set_flip_h(false)
				hurtarea.get_node("CollisionPolygon2D").set_pos(Vector2(-20, 0))
	

func attack():
	if health > 0:
		if cd_timer.get_time_left() == 0:
			sprite.stop()
			sprite.play("atk")
			atk_timer.start()
			cd_timer.start()

func _process(delta):
	if health == 100:
		healthbar.hide()
	else:
		healthbar.show()
	
	if lock.is_visible():
		player.lock_tracking = get_global_pos()
	
	#die 
	healthbar.set_value(health)
	if health <= 0:
		if atk_timer.get_time_left() > 0:
			atk_timer.stop()
		set_layer_mask(2) 
		set_collision_mask(2) # not interactable
		sprite.play("die")
		set_process(false)
		healthbar.hide()
		lock.hide()
		player.lock_tracking = Vector2(-1, -1)


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
	var bodies = hurtarea.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("player"):
			print("player")
			b.get_hit(get_global_pos(), 8)
		else:
			print(typeof(b))


func _on_ClickDetect_mouse_enter():
	mouse_inside = true


func _on_ClickDetect_mouse_exit():
	mouse_inside = false
