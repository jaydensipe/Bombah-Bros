extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.navigation_agent.target_position = actor.pick_random_nav_mesh_point().position
	
	return SUCCESS
