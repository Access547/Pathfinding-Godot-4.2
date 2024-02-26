extends CharacterBody2D
class_name Unit

@onready var navAgent = $NavigationAgent2D
var speed: float = 50

func _physics_process(delta):
	if navAgent.target_position:
		var dir = to_local(navAgent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()



func UpdateTargetPosition(position: Vector2):
	navAgent.target_position = position
	print(str("Target position set: ", navAgent.target_position))
