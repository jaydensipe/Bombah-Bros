extends ActionLeaf

# Configuration
var reached_position: bool = false

func before_run(actor: Node, blackboard: Blackboard) -> void:
	actor.set_state("StateMachine", "Run")

func tick(actor: Node, blackboard: Blackboard) -> int:
	if (reached_position):
		reached_position = false
		
		return SUCCESS
	
	var dir = actor.global_position.direction_to(actor.navigation_agent.get_next_path_position())
	if dir.x != 0:
		actor.velocity.x = lerp(actor.velocity.x, dir.x * actor.speed, actor.acceleration)
	
	if actor.forward_wall_detector.is_colliding() || actor.backward_wall_detector.is_colliding():
		actor.set_state("StateMachine", "Air", {Jump = true})
	
	return RUNNING

func _on_navigation_agent_2d_navigation_finished() -> void:
	reached_position = true
