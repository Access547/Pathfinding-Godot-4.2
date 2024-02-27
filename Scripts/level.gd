extends Node2D

@onready var cam: Camera2D = $Camera2D

var camSpeed: float = 2 #Speed of camera
var unitArray: Array[Unit]
var activeUnitArray: Array[Unit]

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.


func _ready():
	#Grabs an array of units at the start of the game
	var children = get_children()
	for i in children.size():
		if children[i].is_in_group("Moveable"):
			unitArray.append(children[i])
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# If the mouse was clicked and nothing is selected, start dragging
			selected = []
			if selected.size() == 0:
				dragging = true
				drag_start = event.position
				
		# If the mouse is released and is dragging, stop dragging and select the units
		elif dragging:
			for i in activeUnitArray.size():
				activeUnitArray[i].selected = false
			activeUnitArray = []
			dragging = false
			queue_redraw()
			var drag_end = event.position
			select_rect.extents = abs(drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var q = PhysicsShapeQueryParameters2D.new()
			q.shape = select_rect
			q.collision_mask = 1
			q.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(q)
			for item in selected:
				item.collider.selected = true
			for i in selected.size():
				activeUnitArray.append(selected[i].collider)
	if event is InputEventMouseMotion and dragging:
		queue_redraw()
		
func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color.YELLOW, false, 2.0)


func _process(delta):
	
	#Toggle debug mode
	if Input.is_action_just_pressed("Debug"):
		Manager.debug = !Manager.debug
		if Manager.debug:
			print("Debug enabled")
		else:
			print("Debug disabled")

	#Sets camera to move based on wasd input
	var camDirX: float = Input.get_axis("Left","Right") #Gets input of X axis, either -1, 0 or 1
	var camDirY: float = Input.get_axis("Up", "Down") #Gets input of Y axis, either -1, 0 or 1
	if camDirX:
		cam.position.x += camDirX * camSpeed #Adds axis to position
	if camDirY:
		cam.position.y += camDirY * camSpeed #Adds axis to position
	
	
	#This code is a bit messy but just says if you left click, it'll set the target position.
	#If you shift left click, it'll queue that position as it's next target
	if activeUnitArray.size() > 0:
	
		if Input.is_action_just_pressed("R Click", true):
			for i in activeUnitArray.size():
				activeUnitArray[i].UpdateTargetPosition(get_global_mouse_position())
		elif Input.is_action_just_pressed("S R Click", true):
			for i in activeUnitArray.size():
				activeUnitArray[i].QueueTargetPosition(get_global_mouse_position())
