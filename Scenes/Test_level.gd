extends Node2D


var spawn_matrix = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]

func _ready():
	_spawn_matrix(spawn_matrix)
	

func _spawn_matrix(matrix):
	for i in range(len(spawn_matrix)):
		for j in range(len(spawn_matrix[i])):
			var scene = load("res://Scenes/Block.tscn")
			var block = scene.instance()
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
				
			
			block.position = Vector2(100 + i *50, j * 50)
			block.posit = Vector2(i,j)
			matrix[i][j] = block
			
			
			$Wait.start()
			yield($Wait, "timeout")
			add_child(block)

	print(matrix)
	print(matrix[0][2].posit)

var s = [1,1,1]
func _process(delta):
	pass


func _on_activated_session_released():
	Global.last_activated_pos = []
	Global.playing = false
	for i in range(len(spawn_matrix)):
		for j in range(len(spawn_matrix[i])):
			spawn_matrix[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+spawn_matrix[i][j].color+".png")
			spawn_matrix[i][j].selected = false
			Global.selected_blocks = []
