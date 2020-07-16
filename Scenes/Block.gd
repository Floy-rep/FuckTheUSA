extends KinematicBody2D


var color = ""
var selected = false
var posit = Vector2()
var velocity = Vector2()
var speed_falling = 500
const Floor = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	$Sprite.normal = load("res://Textures/Blocks/1.png")


func _process(delta):
	move_and_slide(velocity, Floor)
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = speed_falling

		

func _on_Sprite_pressed():
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
						Global.selected_blocks[-1].get_node("Sprite").normal = load("res://Textures/Blocks/"+color+".png")
						Global.selected_blocks[-1].selected = false
						Global.selected_blocks.remove(len(Global.selected_blocks)-1)
			else:
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
		
		Global.selected_blocks.append($".")
		selected = true
		$Sprite.normal = load("res://Textures/Blocks/selected.png")
		
		Global.last_activated_pos.append(posit.x)
		Global.last_activated_pos.append(posit.y)
