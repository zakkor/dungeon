extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var sprite = get_node("AnimatedSprite")
onready var hit_timer = get_node("hit_timer")
onready var death_timer = get_node("DeathTimer")
onready var area = get_node("Area2D")
onready var healthbar = get_node("HUD/HealthBar")
onready var blood = get_node("Particles2D")

var health = 100
var moving = false
var locked = false
var lock_tracking = Vector2(-1, -1)
var last_bonfire

const SPEED = 70

func _ready():
	set_fixed_process(true)
	set_process(true)
	set_process_input(true)
	pass
	
func _input(event):
	if health > 0:
		if (event.is_action_released("light_toggle")):
			var light = get_node("Light2D")
			if light.is_visible():
				light.hide()
			else:
				light.show()
			
		if event.is_action_pressed("lock"):	
			locked = !locked
		
		if event.is_action_pressed("attack"):
			# stop anything that might be playing
			sprite.stop()
			sprite.play("attack")
			# start hit timer
			hit_timer.start()

func _process(delta):
	healthbar.set_value(health)
	# die
	if health <= 0:
		if sprite.get_animation() != "die":
			print("called, current anim is:" ,sprite.get_animation())
			sprite.stop()
			sprite.play("die")
			death_timer.start()
	else:
		if lock_tracking != Vector2(-1, -1):
			# flip h depending on xpos
			if lock_tracking.x > get_global_pos().x and sprite.is_flipped_h():
				sprite.set_flip_h(false)
				area.get_node("CollisionPolygon2D").set_pos(Vector2(18, 0))
			else:
				if lock_tracking.x < get_global_pos().x and !sprite.is_flipped_h():
					sprite.set_flip_h(true)
					area.get_node("CollisionPolygon2D").set_pos(Vector2(-18, 0))

func get_hit(location, damage):
	var angle = Vector2(4, 4) * (get_global_pos() - location)
	var rad = atan2(angle.y, angle.x)
	var deg = rad * 180 / 3.14159 + 90
	health -= damage;
	blood.set_param(blood.PARAM_DIRECTION, deg)
	blood.set_emitting(true)

func _fixed_process(delta):
	if health > 0:
		var mv = Vector2(0, 0)
		if (Input.is_action_pressed("move_up")):
			mv += Vector2(0, -1)
		if (Input.is_action_pressed("move_down")):
			mv += Vector2(0, 1)
		if (Input.is_action_pressed("move_left")):
			mv += Vector2(-1, 0)
			
			if lock_tracking == Vector2(-1, -1):
				sprite.set_flip_h(true)
				area.get_node("CollisionPolygon2D").set_pos(Vector2(-18, 0))
		if (Input.is_action_pressed("move_right")):
			mv += Vector2(1, 0)
			
			if lock_tracking == Vector2(-1, -1):
				sprite.set_flip_h(false)
				area.get_node("CollisionPolygon2D").set_pos(Vector2(18, 0))
			
		move(mv * Vector2(0.9, 0.9))
		
		if mv != Vector2(0, 0) and sprite.get_animation() == "idle":
			sprite.stop()
			pass
		
		if mv != Vector2(0, 0) and !sprite.is_playing():
			sprite.play("walk")
			moving = true
			
		#stop early 
		if sprite.get_animation() == "walk" and mv == Vector2(0, 0) and sprite.is_playing():
			sprite.stop()
			sprite.set_frame(0)
		moving = false

func _on_AnimatedSprite_finished():
	if health > 0:
		sprite.play("idle")
	pass


func _on_idle_timer_timeout():
	if health > 0:
		if !sprite.is_playing():
			sprite.play("idle")


func _on_hit_timer_timeout():
	var bodies = area.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("enemy"):
			b.get_hit(get_global_pos())
		else:
			print(typeof(b))
		pass
	

func _on_DeathTimer_timeout():
	health = 100
	set_global_pos(last_bonfire.get_global_pos())
	last_bonfire.activate(self)
	sprite.play("idle")
