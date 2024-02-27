extends CharacterBody2D
class_name Unit

@onready var navAgent = $NavigationAgent2D
@onready var animPlayer = $AnimationPlayer


var speed: float = 50
var posArray: Array[Vector2]
var selected: bool = false


func _process(_delta):
	#Set debugging
	if navAgent.debug_enabled != Manager.debug:
		navAgent.debug_enabled = Manager.debug

func _physics_process(_delta):
	#Movement (Note the unit only moves when it's got a target position to go to
	if navAgent.target_position:
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()
	
		#Animation setting
		if dir:
			animPlayer.play("Moving")
		else:
			animPlayer.play("Idle")
	
	


#Function that just updates the units target position with a Vector2 position
func UpdateTargetPosition(position: Vector2):
	posArray.clear()
	posArray.push_front(position)
	navAgent.target_position = posArray[0]
	
	
func QueueTargetPosition(position: Vector2):
	posArray.push_back(position)


#Signal that emits when target has reached its destination
func _on_navigation_agent_2d_navigation_finished():
	if !posArray.is_empty():
		if posArray[0]:
			posArray.pop_front()
			if !posArray.is_empty():
				navAgent.target_position = posArray[0]
			else:
				navAgent.target_position = Vector2(0,0)



