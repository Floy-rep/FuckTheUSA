extends Node2D

### VARIABLES ###

var spawn_matrix = [[1,0,0,0,0,0,0],[0,0,0,0,0,0],[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0], [0,0,0,0,0,0], [1,0,0,0,0,0,0]]
#var spawn_matrix = [[1,0,0],[0,0,0],[1,0,0]]
var matrix_ready = []
var launch = false

func _ready():
	_spawn_matrix(spawn_matrix)

func _process(delta):
	if $Game_Timer.is_stopped():
		Global.playing_by_timer = true
	else:
		Global.playing_by_timer = false

### CLEARING DE MATRIX FROM NULL OBJECTS ###

func _clear_matrix(matrix):
	print(matrix)
	for i in range(len(matrix)):
		matrix_ready.append([])
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) != 2:
				matrix_ready[i].append(matrix[i][j])

### GENERATING NEW BLOCKS ###

func _spawn_matrix(matrix):
	for i in range(len(matrix)):
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) == 2:
				var scene = load("res://Scenes/Block.tscn")
				var block = scene.instance()
				if matrix[i][j] == 0:
					
					### CHOOSING THE COLOR ###
					
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
						
					### SET DE POSITION ###
						
					if launch == false:
						block.posit = Vector2(i,j)
					else:
						block.posit = Vector2(i, j + spawn_matrix[i].count(1))
					matrix[i][j] = block
	
				elif matrix[i][j] == 1:
					block.nulled = true
					block.visible = false
				
				### SPAWN BLOCK ###
				
				block.position = Vector2(125 + i *50, j * 50)
				$Wait.start()
				yield($Wait, "timeout")
				add_child(block)
				
			else:
				continue

	if launch == false:
		_clear_matrix(matrix)
		launch = true
		$Start.visible = true
		
	if launch:
		Global.can_play = true

### CHECKING PROCESSING OF DE GAME ###

func _on_activated_session_released():
	if Global.can_play:
		Global.last_activated_pos = []
		
		### SET NORMAL COLORS ###
		
		for i in range(len(matrix_ready)):
			for j in range(len(matrix_ready[i])):
				matrix_ready[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+matrix_ready[i][j].color+".png")
				matrix_ready[i][j].selected = false
		
		### DELETING CHOOSED BLOCKS ###
		
		if len(Global.selected_blocks) >= 3 :
			for j in range (len(matrix_ready)):
				for h in range(len(matrix_ready[j])):
					for i in Global.selected_blocks:
						if str(matrix_ready[j][h]) == str(i):
							matrix_ready[j][h] = 0
							get_child(i.get_index()).queue_free()
							break
			
			### ADAPTING MATRIX ###
			
			for i in range(len(matrix_ready)):
				for j in range(len(matrix_ready[i])):
					if typeof(matrix_ready[i][j]) == 2:
						matrix_ready[i].push_back(matrix_ready[i][j])
						matrix_ready[i].remove(matrix_ready[i].find(matrix_ready[i][j]))
			
			### SET DE NEW POSITION OF OLD BLOCKS ###
			
			for i in range(len(matrix_ready)):
				for j in range(len(matrix_ready[i])):
					if typeof(matrix_ready[i][j]) != 2:
						matrix_ready[i][j].posit = Vector2(i,j + spawn_matrix[i].count(1))
		
			$Score.text = "Score: " + str(int($Score.text.lstrip(7)) + len(Global.selected_blocks))
		
		### CALL FUCNTION TO SPAWN NEW BLOCKS ###
		
		if len(Global.selected_blocks) >= 3:
			Global.selected_blocks = []
			Global.can_play = false
			_spawn_matrix(matrix_ready)
		else:
			Global.selected_blocks = []
			if $Game_Timer.is_stopped() == false:
				Global.can_play = true

### NEW GAME ###

func _on_Start_pressed():
	Global.can_play = true
	$Score.text = "Score: 0" 
	$Game_Timer.start()
	
### TIMER OF NEW GAME ###
	
func _on_Game_Timer_timeout():
	if int($Seconds/Numbers.text) > 30 :
		$Seconds/Numbers.modulate = ColorN("green")
	elif int($Seconds/Numbers.text) < 31 and int($Seconds/Numbers.text)  > 10:
		$Seconds/Numbers.modulate = ColorN("yellow")
	elif int($Seconds/Numbers.text)  < 11:
		$Seconds/Numbers.modulate = ColorN("red")
		
	if int($Seconds/Numbers.text) <= 0:
		$Game_Timer.stop()
		_on_activated_session_released()
		$Seconds/Numbers.text = "61"
		$Seconds/Numbers.modulate = ColorN("green")
		Global.selected_blocks = []
		Global.can_play = false
		
	$Seconds/Numbers.text = str(int($Seconds/Numbers.text) - 1)
