extends KinematicBody2D


var color = ""
var posit = Vector2()
var velocity = Vector2()
var speed_falling = 500
const Floor = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.normal = load("res://Textures/Blocks/1.png")


func _process(delta):
	move_and_slide(velocity, Floor)
	
	if is_on_floor():
		velocity.y = 0
#		print("floor")
	else:
		velocity.y = speed_falling
#		print("not floor")
		

var can_be_toched = true
func _on_Sprite_pressed():
	print(Global.last_activated_pos)
	
	if len(Global.last_activated_pos) > 0:
		if (abs(Global.last_activated_pos[0] - posit.x) == 1 and abs(Global.last_activated_pos[1] - posit.y) == 1)\
		or (abs(Global.last_activated_pos[0] - posit.x) == 1 and abs(Global.last_activated_pos[1] - posit.y) == 0)\
		or (abs(Global.last_activated_pos[0] - posit.x) == 0 and abs(Global.last_activated_pos[1] - posit.y) == 1)\
		or (Global.last_activated_pos[0] == posit.x and Global.last_activated_pos[1] == posit.y):
			print("good")
			Global.last_activated_pos[0] = posit.x
			Global.last_activated_pos[1] = posit.y
		else:
			print(posit)
			print("too far")
	else:
		print("first")
		Global.last_activated_pos.append(posit.x)
		Global.last_activated_pos.append(posit.y)
		print(Global.last_activated_pos)
		
