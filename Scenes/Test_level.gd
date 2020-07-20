extends Node2D


var spawn_matrix = [[1,0,0,0,0,0,0],[0,0,0,0,0,0],[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0], [0,0,0,0,0,0], [1,0,0,0,0,0,0]]
#var spawn_matrix = [[1,0,0],[0,0,0],[1,0,0]]
var matrix_ready = []
var launch = false

func _ready():
	_spawn_matrix(spawn_matrix)
	

func _clear_matrix(matrix):
	print(matrix)
	for i in range(len(matrix)):
		matrix_ready.append([])
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) != 2:
				matrix_ready[i].append(matrix[i][j])

	print(matrix_ready)

func _spawn_matrix(matrix):
	for i in range(len(matrix)):
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) == 2:
				var scene = load("res://Scenes/Block.tscn")
				var block = scene.instance()
				if matrix[i][j] == 0:
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
					if launch == false:
						block.posit = Vector2(i,j)
					else:
						print(spawn_matrix[i])
						print(spawn_matrix[i].count(1))
						block.posit = Vector2(i, j + spawn_matrix[i].count(1))
					matrix[i][j] = block
	
				elif matrix[i][j] == 1:
					block.nulled = true
					block.visible = false
					
				block.position = Vector2(125 + i *50, j * 50)
				$Wait.start()
				yield($Wait, "timeout")
				
				add_child(block)
			else:
				continue

	if launch == false:
		_clear_matrix(matrix)
		launch = true
	Global.can_play = true
#func _process(delta):
#	pass

func _on_activated_session_released():
	if Global.can_play:
		Global.last_activated_pos = []
		
	
		for i in range(len(matrix_ready)):
			for j in range(len(matrix_ready[i])):
				matrix_ready[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+matrix_ready[i][j].color+".png")
				matrix_ready[i][j].selected = false
	#	print(Global.selected_blocks)
		
		for j in range (len(matrix_ready)):
			for h in range(len(matrix_ready[j])):
				for i in Global.selected_blocks:
					if str(matrix_ready[j][h]) == str(i):
						matrix_ready[j][h] = 0
						get_child(i.get_index()).queue_free()
						break
		
		
		for i in range(len(matrix_ready)):
			for j in range(len(matrix_ready[i])):
				if typeof(matrix_ready[i][j]) == 2:
					matrix_ready[i].push_back(matrix_ready[i][j])
					matrix_ready[i].remove(matrix_ready[i].find(matrix_ready[i][j]))
						
		for i in range(len(matrix_ready)):
			for j in range(len(matrix_ready[i])):
				if typeof(matrix_ready[i][j]) != 2:
					matrix_ready[i][j].posit = Vector2(i,j + spawn_matrix[i].count(1))
	
		$Score.text = "Score: " + str(int($Score.text.lstrip(7)) + len(Global.selected_blocks))
		
		Global.selected_blocks = []
		print(matrix_ready)
		print("")
		Global.can_play = false
		_spawn_matrix(matrix_ready)

