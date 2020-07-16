extends Node2D


var spawn_matrix = [[1,0,0,0,0,0,0],[0,0,0,0,0,0],[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0], [0,0,0,0,0,0], [1,0,0,0,0,0,0]]
var matrix_ready = []

func _ready():
	_spawn_matrix(spawn_matrix)
	

func _clear_matrix(matrix):
	print(matrix)
	var to_delete = 0
	for i in range(len(matrix)):
		matrix_ready.append([])
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) != 2:
				matrix_ready[i].append(matrix[i][j])
				

	print(matrix_ready)

func _spawn_matrix(matrix):
	for i in range(len(spawn_matrix)):
		for j in range(len(spawn_matrix[i])):
			var scene = load("res://Scenes/Block.tscn")
			var block = scene.instance()
			if spawn_matrix[i][j] == 0:
				randomize()
				var color = randi()%4+1
				if color == 1:
					block.color = "blue"
					block.get_node("Sprite").normal = load("res://Textures/Blocks/blue.png")
				if color == 2:
					block.color = "red"
					block.get_node("Sprite").normal = load("res://Textures/Blocks/red.png")
				if color == 3:
					block.color = "yellow"
					block.get_node("Sprite").normal = load("res://Textures/Blocks/yellow.png")
				if color == 4:
					block.color = "green"
					block.get_node("Sprite").normal = load("res://Textures/Blocks/green.png")
					
				block.position = Vector2(125 + i *50, j * 50)
				block.posit = Vector2(i,j)
				matrix[i][j] = block

			elif matrix[i][j] == 1:
				block.nulled = true
				block.visible = false
				
			block.position = Vector2(125 + i *50, j * 50)
			$Wait.start()
			yield($Wait, "timeout")
			add_child(block)
			
	_clear_matrix(spawn_matrix)
	
#func _process(delta):
#	pass

func _on_activated_session_released():
	Global.last_activated_pos = []
	Global.playing = false
	for i in range(len(matrix_ready)):
		for j in range(len(matrix_ready[i])):
			matrix_ready[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+matrix_ready[i][j].color+".png")
			matrix_ready[i][j].selected = false
#	print(Global.selected_blocks)
#	print(matrix_ready)
	Global.selected_blocks = []
