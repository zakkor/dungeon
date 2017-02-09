extends Node2D

onready var player = get_node("walls/player")
onready var torches = get_tree().get_nodes_in_group("torch")
onready var interactLabel = get_node("HUD/interact")
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
	var space_state = get_world_2d().get_direct_space_state()
	#var result = space_state.intersect_ray(enemy.get_global_pos(), player.get_global_pos(), [enemy])
	#if (not result.empty()):
		#print("Hit at point: ", result.position)
		#enemy.set_fixed_process(false)
		#pass
	#else:
		#pass


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