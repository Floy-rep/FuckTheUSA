extends Node2D

#### VARIABLES ###
#var spawn_matrix = [[1,0,0,0,0,0,0],[0,0,0,0,0,0],[1,1,0,0,0,0,0,0],[1,1,0,0,0,0,0,0], [0,0,0,0,0,0], [1,0,0,0,0,0,0]]
var spawn_matrix = [[1,2,2,2,0,0,0],[2,2,2,0,0,0],[1,1,2,2,2,0,0,0],[1,1,2,2,2,0,0,0], [2,2,2,0,0,0], [1,2,2,2,0,0,0]]

#var spawn_matrix = [[1,0,0],[0,0,0],[1,0,0]]
#var spawn_matrix = [[1,0,0,0,0], [1,0,0,0,0], [0,0,0,0,0]]
var matrix_ready = []
var matrix_for_bonus = []
var launch = false

var can_spawn_bonus = true
var Score = 0


func _ready():
	_spawn_matrix(spawn_matrix)

func _process(delta):
	if $Game_Timer.is_stopped():
		Global.playing_by_timer = true
	else:
		Global.playing_by_timer = false

### CLEARING DE MATRIX FROM NULL OBJECTS ###

func _clear_matrix(matrix):
#    print(matrix)
	for i in range(len(matrix)):
		matrix_ready.append([])
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) != 2:
				matrix_ready[i].append(matrix[i][j])

### GENERATING NEW BLOCKS ###

func _spawn_matrix(matrix):
#    print(Global.selected_color)
	for i in range(len(matrix)):
		for j in range(len(matrix[i])):
			if typeof(matrix[i][j]) == 2:
				var scene = load("res://Scenes/Block.tscn")
				var block = scene.instance()
				block.scale = Vector2(1.3,1.3)
				if matrix[i][j] == 0 or matrix[i][j] == 2:
					
					### CHOOSING THE COLOR ###
					
					randomize()
					var color = randi()%4+1
					if color == 1:
						block.color = "blue"
						if matrix[i][j] == 2:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/blue_chained.png")
						else:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/blue.png")
							
					if color == 2:
						block.color = "red"
						if matrix[i][j] == 2:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/red_chained.png")
						else:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/red.png")
							
					if color == 3:
						block.color = "yellow"
						if matrix[i][j] == 2:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/yellow_chained.png")
						else:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/yellow.png")
					if color == 4:
						block.color = "green"
						if matrix[i][j] == 2:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/green_chained.png")
						else:
							block.get_node("Sprite").normal = load("res://Textures/Blocks/green.png")
					
					if matrix[i][j] == 2:
						block.bonus = "chained"
					
				elif matrix[i][j] == 1:
					block.nulled = true
					block.visible = false
				
				elif matrix[i][j] == 3:
					block.color = Global.selected_color
					block.get_node("Sprite").normal = load("res://Textures/Blocks/" + Global.selected_color + "_hor.png")
					block.bonus = "hor"
					
				elif matrix[i][j] == 4:
					block.color = Global.selected_color
					block.get_node("Sprite").normal = load("res://Textures/Blocks/" + Global.selected_color + "_ver.png")
					block.bonus = "ver"
					
				elif matrix[i][j] == 5:
					block.color = Global.selected_color
					block.get_node("Sprite").normal = load("res://Textures/Blocks/" + Global.selected_color + "_bomb.png")
					block.bonus = "bomb"
					
				elif matrix[i][j] == 6:
					block.color = Global.selected_color
					block.get_node("Sprite").normal = load("res://Textures/Blocks/" + Global.selected_color + "_skull.png")
					block.bonus = "skull"
					
				### SET DE POSITION OF BLOCK ###
				
				if matrix[i][j] != 1:
					if launch == false:
						block.posit = Vector2(i,j)
					else:
						block.posit = Vector2(i, j + spawn_matrix[i].count(1))
					matrix[i][j] = block
				
				### SPAWN BLOCK ###
				
				block.position = Vector2(70 + i * 65, j * 20)
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


func _deleting_blocks(i,j,h):
	if i.bonus == "":
		get_child(i.get_index()).queue_free()
		matrix_ready[j][h] = 0
		Score += 1
	else:
		
		if i.bonus == "hor":
			i.bonus = ""
			for g in range (len(matrix_ready)):
				for f in range(len(matrix_ready[g])):
					if typeof(matrix_ready[g][f]) != 2:
						if matrix_ready[g][f].posit.y == i.posit.y:
							_deleting_blocks(matrix_ready[g][f], g, f)
							
		elif i.bonus == "ver":
			i.bonus = ""
			for g in range(len(matrix_ready[i.posit.x])):
				if typeof(matrix_ready[i.posit.x][g]) != 2:
					_deleting_blocks(matrix_ready[i.posit.x][g], i.posit.x, g)
		
		elif i.bonus == "bomb":
			i.bonus = ""
			for g in range(-1, 2, 1):
				for f in range(-1, 2, 1):
					if g + i.posit.x >= 0 and g + i.posit.x < len(matrix_ready):
						var minus_y = spawn_matrix[g + i.posit.x].count(1)
						if f + i.posit.y - minus_y >= 0  and f + i.posit.y - minus_y < len (matrix_ready[g+i.posit.x]):
							if typeof(matrix_ready[g + i.posit.x][f + i.posit.y - minus_y]) != 2:
								_deleting_blocks(matrix_ready[g + i.posit.x][f + i.posit.y - minus_y], g + i.posit.x, f + i.posit.y - minus_y)
		
		elif i.bonus == "skull":
			i.bonus = ""
			for g in range(len(matrix_ready)):
				for f in range(len(matrix_ready[g])):
					if typeof(matrix_ready[g][f]) != 2:
						_deleting_blocks(matrix_ready[g][f], g, f)
		
		elif i.bonus == "chained":
			i.bonus = ""
			i.get_node("Sprite").normal = load("res://Textures/Blocks/" + i.color + ".png")

### FUNC DELETING BLOCKS ###

func _update_blocks():
		
	### ADAPTING MATRIX ###
	
	var buffer
	for i in range(len(matrix_ready)):
		for j in range(len(matrix_ready[i])): 
			for h in range(len(matrix_ready[i])-j-1): 
				if typeof(matrix_ready[i][h]) < typeof(matrix_ready[i][h+1]) : 
					buffer = matrix_ready[i][h]
					matrix_ready[i][h] = matrix_ready[i][h+1]
					matrix_ready[i][h+1] = buffer

	### SET DE NEW POSITION OF OLD BLOCKS ###
	
	for i in range(len(matrix_ready)):
		for j in range(len(matrix_ready[i])):
			if typeof(matrix_ready[i][j]) != 2:
				matrix_ready[i][j].posit = Vector2(i,j + spawn_matrix[i].count(1))
	
	$Score.text = "Score: " + str(int($Score.text.lstrip(7)) + Score)

### CHECKING PROCESSING OF DE GAME ###

func _on_activated_session_released():
	Global.bonus_spawned = false
	if Global.can_play :
		Global.last_activated_pos = []
		
		### SET NORMAL COLORS ###
		
		for i in range(len(matrix_ready)):
			for j in range(len(matrix_ready[i])):
				if typeof(matrix_ready[i][j]) != 2:
					if matrix_ready[i][j].bonus == "": 
						matrix_ready[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+matrix_ready[i][j].color+".png")
					else:
						matrix_ready[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+matrix_ready[i][j].color + "_" + matrix_ready[i][j].bonus + ".png")
					matrix_ready[i][j].selected = false
		
		### CHECKING FOR CHAINED BLOCKS ###
		
		for i in range(len(Global.selected_blocks)):
				if Global.selected_blocks[i].bonus != "chained":
					matrix_for_bonus.append(Global.selected_blocks[i])
		
		### DELETING CHOOSED BLOCKS ###
		
		if len(Global.selected_blocks) >= 3 :
			Score = 0
			for j in range (len(matrix_ready)):
				for h in range(len(matrix_ready[j])):
					for i in Global.selected_blocks:
						if str(matrix_ready[j][h]) == str(i):
							_deleting_blocks(i,j,h)
		
		### SPAWN BONUSES ###
		
			if len(matrix_for_bonus) > 0:
				var pos = matrix_for_bonus[-1].posit
				pos.y -= spawn_matrix[pos.x].count(1)
				var bonus = randi()%2+1
				
				if len(Global.selected_blocks) >= 5 and len(Global.selected_blocks) < 8:

					if bonus == 1:
						matrix_ready[pos.x][pos.y] = 3

					elif bonus == 2:
						matrix_ready[pos.x][pos.y] = 4
				
				if len(Global.selected_blocks) >= 8 and len(Global.selected_blocks) < 12:
					matrix_ready[pos.x][pos.y] = 5
				
				if len(Global.selected_blocks) >= 12:
					matrix_ready[pos.x][pos.y] = 6
					
				matrix_for_bonus = []

			_update_blocks()
			
		### CALL FUNCTION TO SPAWN NEW BLOCKS ###
		
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
		
		for i in range(len(matrix_ready)):
			for j in range(len(matrix_ready[i])):
				if typeof(matrix_ready[i][j]) != 2:
					matrix_ready[i][j].get_node("Sprite").normal = load("res://Textures/Blocks/"+matrix_ready[i][j].color+".png")
					matrix_ready[i][j].bonus = ""
		
		Global.can_play = false
		
	$Seconds/Numbers.text = str(int($Seconds/Numbers.text) - 1)

### BONUSES IN THE TOP ###

func _set_color_for_bonuses(bonus):
	var bonus_to_off
	if Global.bonus_activated != bonus:
		bonus_to_off = Global.bonus_activated
		Global.bonus_activated = ""
		
	if Global.bonus_activated == "":
		Global.bonus_activated = bonus
		get_node("bonuses/" + Global.bonus_activated).normal = load("res://Textures/Blocks/selected.png")
		if bonus_to_off != "":
			get_node("bonuses/" + bonus_to_off).normal = load("res://Textures/Blocks/blue_"+  bonus_to_off + ".png")
	else:
		get_node("bonuses/" + Global.bonus_activated).normal = load("res://Textures/Blocks/blue_"+  Global.bonus_activated + ".png")
		Global.bonus_activated = ""
	
func _on_TouchScreenButton_released():
	_set_color_for_bonuses("skull")

func _on_ver_released():
	_set_color_for_bonuses("ver")

func _on_hor_released():
	_set_color_for_bonuses("hor")

func _on_bomb_released():
	_set_color_for_bonuses("bomb")

func _on_shovel_released():
	_set_color_for_bonuses("shovel")

