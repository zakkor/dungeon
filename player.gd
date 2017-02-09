extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var sprite = get_node("AnimatedSprite")
onready var hit_timer = get_node("hit_timer")
onready var area = get_node("Area2D")

var moving = false

const SPEED = 70

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	pass
	
func _input(event):
	if (event.is_action_released("light_toggle")):
		var light = get_node("Light2D")
		var is_enabled = light.is_enabled()
		light.set_enabled(!is_enabled)
		
	if event.is_action_pressed("attack"):
		# stop anything that might be playing
		sprite.stop()
		sprite.play("attack")
		
		# start hit timer
		hit_timer.start()
	
func _fixed_process(delta):
	var mv = Vector2(0, 0)
	if (Input.is_action_pressed("move_up")):
		mv += Vector2(0, -1)
	if (Input.is_action_pressed("move_down")):
		mv += Vector2(0, 1)
	if (Input.is_action_pressed("move_left")):
		sprite.set_flip_h(true)
		area.get_node("CollisionPolygon2D").set_pos(Vector2(-18, 0))
		mv += Vector2(-1, 0)
	if (Input.is_action_pressed("move_right")):
		mv += Vector2(1, 0)
		sprite.set_flip_h(false)
		area.get_node("CollisionPolygon2D").set_pos(Vector2(18, 0))
		
	move(mv * Vector2(0.9, 0.9))
	
	if mv != Vector2(0, 0) and sprite.get_animation() == "idle":
		sprite.stop()
	
	if mv != Vector2(0, 0) and !sprite.is_playing():
		sprite.play("walk")
		moving = true
		
	#stop early 
	if sprite.get_animation() == "walk" and mv == Vector2(0, 0) and sprite.is_playing():
		sprite.stop()
		sprite.set_frame(0)
		moving = false

func _on_AnimatedSprite_finished():
	sprite.stop()


func _on_idle_timer_timeout():
	if !sprite.is_playing():
		sprite.play("idle")


func _on_hit_timer_timeout():
	hit_timer.stop()
	var bodies = area.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("enemy"):
			b.apply_impulse(Vector2(0, 0), Vector2(4, 4) * (b.get_global_pos() - get_global_pos()))
			b.health -= 30;
			b.get_node("AnimatedSprite").play("grunt")
			print(b.health)
		else:
			print(typeof(b))
		pass
	