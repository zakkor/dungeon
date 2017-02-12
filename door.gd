extends Node2D

onready var area = get_node("InteractArea")
onready var open = get_node("Open")
onready var closed = get_node("Closed")
onready var closed_body = get_node("ClosedBody")
onready var open_body = get_node("OpenBody")
onready var label = get_node("HUD/CenterContainer/InteractLabel")
onready var open_occlud = get_node("OpenOcclud")
onready var closed_occlud = get_node("ClosedOcclud")

func _process(delta):	
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
	if player_in_range():
		toggle()

func toggle():
	# close it
	if !closed.is_visible():
		closed.show()
		open.hide()
		
		closed_body.set_layer_mask(1)
		closed_body.set_collision_mask(1)
		
		open_body.set_layer_mask(2)
		open_body.set_collision_mask(2)
		
		open_occlud.set_occluder_light_mask(2)
		closed_occlud.set_occluder_light_mask(1)
	else:
		closed.hide()
		open.show()
		
		closed_body.set_layer_mask(2)
		closed_body.set_collision_mask(2)
		
		open_body.set_layer_mask(1)
		open_body.set_collision_mask(1)
		
		open_occlud.set_occluder_light_mask(1)
		closed_occlud.set_occluder_light_mask(2)
	

func _ready():
	set_process(true)
