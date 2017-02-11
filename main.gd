extends Node2D

onready var player = get_node("walls/player")
onready var torches = get_tree().get_nodes_in_group("torch")
onready var interactLabel = get_node("HUD/interact")
onready var debugvis = get_node("DebugVis")
onready var enemies = get_tree().get_nodes_in_group("enemy")

func can_use_item(char, item):
  # char and item are Nodes
  if char.get_global_pos().distance_to(item.get_global_pos()) <= 10:
    return true
  return false

func _ready():
	set_process(true)
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	var exclude = enemies
	exclude.push_back(get_node("walls"))
	exclude.push_back(player)
		
	for e in enemies:
		if e.health <=0:
			continue
		
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(e.get_global_pos(), player.get_global_pos() + Vector2(0, 22), exclude)
		if (not result.empty()):
			#print(result.position)
			var col = Color(255, 0, 0, 1)
			debugvis.lines.push_back(player.get_global_pos() + Vector2(0, 22))
			debugvis.lines.push_back(result.position)
			debugvis.update()
			#enemy.set_fixed_process(false)
			pass
		else:
			if e.get_global_pos().distance_to(player.get_global_pos()) > 32:
				e.move_towards(player.get_global_pos())
			else:
				e.attack()


func _input(event):
	if event.is_action_released("interact"):
		for torch in torches:	
			if can_use_item(player, torch):
				torch.toggle()
				break

func _process(delta):
	var torch_contact = false
	for torch in torches:	
		if can_use_item(player, torch):
			torch_contact = true
			break
		
	if torch_contact:
		interactLabel.show()
	else:
		interactLabel.hide()
		
	update()