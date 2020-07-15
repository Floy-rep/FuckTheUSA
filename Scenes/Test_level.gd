extends Node2D


var spawn_matrix = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]

func _ready():
	_spawn_matrix(spawn_matrix)
	

func _spawn_matrix(matrix):
	for i in range(len(spawn_matrix)):
		for j in range(len(spawn_matrix[i])):
			var scene = load("res://Scenes/Block.tscn")
			var block = scene.instance()
			block.position = Vector2(i *50, j * 50)
			$Wait.start()
			yield($Wait, "timeout")
			add_child(block)
			block.posit = Vector2(i,j)
			matrix[i][j] = block
	print(matrix)
	print(matrix[0][2].posit)


func _process(delta):
	pass
#	print(get_children())
#
#
#func _on_TouchScreenButton_pressed():
#	Global.last_activated_pos = []
#	Global.playing = true


func _on_activated_session_released():
	Global.last_activated_pos = []
	Global.playing = false
