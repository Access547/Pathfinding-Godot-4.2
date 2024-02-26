extends CharacterBody2D
class_name Unit

@onready var navAgent = $NavigationAgent2D
@onready var animPlayer = $AnimationPlayer


var speed: float = 50

func _physics_process(delta):
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
	navAgent.target_position = position


#Signal that emits when target has reached its destination
func _on_navigation_agent_2d_navigation_finished():
	navAgent.target_position = Vector2(0,0)
