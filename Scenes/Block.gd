extends KinematicBody2D

### VARIABLES ###

var color = ""
var bonus = ""
var stable = false

var stopped = false

var nulled = false
var selected = false
var posit = Vector2()
var posit_in_array = Vector2()

var velocity = Vector2()
var speed_falling = 3000
const Floor = Vector2(0, -1)


#func _ready():
#	$".".set_collision_mask(1)


### FALLING BLOCKS ###

func _process(delta):
	if stopped == false:
		move_and_slide(velocity, Floor)
	if is_on_floor():
		if stable:
			stopped = true
		speed_falling = 400
		velocity.y = 0
	else:
		velocity.y = speed_falling

### TOUCHING DE BLOCK ###

func _on_Sprite_pressed():
	print(posit)
	print(posit_in_array)
	print()

	if nulled == false:
		if Global.can_play and Global.playing_by_timer == false and Global.bonus_spawned == false:
			if len(Global.last_activated_pos) > 0:
				
				### FIX MUTLI-TOUCH ###
				
				if (abs(Global.last_activated_pos[0] - posit.x) == 1 and abs(Global.last_activated_pos[1] - posit.y) == 1)\
				or (abs(Global.last_activated_pos[0] - posit.x) == 1 and abs(Global.last_activated_pos[1] - posit.y) == 0)\
				or (abs(Global.last_activated_pos[0] - posit.x) == 0 and abs(Global.last_activated_pos[1] - posit.y) == 1)\
				or (Global.last_activated_pos[0] == posit.x and Global.last_activated_pos[1] == posit.y):
					
					if selected:
					
						### FIX SNAKE ###
						
						if len(Global.selected_blocks) > 1:
							if Global.selected_blocks[-2] == $".":
								
								if Global.selected_blocks[-1].bonus == "":
									Global.selected_blocks[-1].get_node("Sprite").normal = load("res://Textures/Blocks/"+color+".png")
								else:
									Global.selected_blocks[-1].get_node("Sprite").normal = load("res://Textures/Blocks/"+Global.selected_blocks[-1].color + "_"+ Global.selected_blocks[-1].bonus + ".png")
									
								Global.selected_blocks[-1].selected = false
								Global.selected_blocks.remove(len(Global.selected_blocks)-1)
								
								Global.last_activated_pos[0] = posit.x
								Global.last_activated_pos[1] = posit.y
					else:
						
						if Global.selected_color == color:
							$Sprite.normal = load("res://Textures/Blocks/selected.png")
							Global.selected_blocks.append($".")
							selected = true
						
							Global.last_activated_pos[0] = posit.x
							Global.last_activated_pos[1] = posit.y
					print("good")
				else:
					print("too far")
			else:
				print("first")
				
				if Global.bonus_activated != "":
					
					### SHOVEL ###
					
					if Global.bonus_activated == "shovel":
						get_node("../").shovel($".")
						
					else:
						
						### BONUSES ###
						
						if bonus != "chained":
							bonus = Global.bonus_activated
							$Sprite.normal = load("res://Textures/Blocks/"+color+"_"+Global.bonus_activated+".png")
							Global.bonus_spawned = true
							get_node("../bonuses/" + Global.bonus_activated).normal = load("res://Textures/Blocks/blue_"+ Global.bonus_activated + ".png")
							Global.bonus_activated = ""
				else:
					Global.selected_blocks.append($".")
					selected = true
					$Sprite.normal = load("res://Textures/Blocks/selected.png")
					
					Global.last_activated_pos.append(posit.x)
					Global.last_activated_pos.append(posit.y)
					Global.selected_color = color
