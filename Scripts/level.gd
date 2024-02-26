extends Node2D

@onready var cam: Camera2D = $Camera2D

var camSpeed: float = 2 #Speed of camera
var unitArray: Array[Unit]


func _ready():
	#Grabs an array of units at the start of the game
	var children = get_children()
	for i in children.size():
		if children[i].is_in_group("Moveable"):
			unitArray.append(children[i])
		


func _process(delta):
	#Sets camera to move based on wasd input
	var camDirX: float = Input.get_axis("Left","Right") #Gets input of X axis, either -1, 0 or 1
	var camDirY: float = Input.get_axis("Up", "Down") #Gets input of Y axis, either -1, 0 or 1
	if camDirX:
		cam.position.x += camDirX * camSpeed #Adds axis to position
	if camDirY:
		cam.position.y += camDirY * camSpeed #Adds axis to position
	
	
	if Input.is_action_just_pressed("Click"):
		for i in unitArray.size():
			unitArray[i].UpdateTargetPosition(get_global_mouse_position())
		
		
		