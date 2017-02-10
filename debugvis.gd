extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var lines = []

func _draw():
	var col = Color(255, 0, 0, 1)
	for i in range( lines.size() ):
		if i > 0:
			draw_line(lines[i-1], lines[i], col)
	lines.clear()
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
