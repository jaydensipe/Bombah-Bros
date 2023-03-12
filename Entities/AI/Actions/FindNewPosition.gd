extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.navigation_agent.target_position = Vector2(GlobalGameInformation.pick_random_nav_mesh_point().x * 10.0, GlobalGameInformation.pick_random_nav_mesh_point().y)
	
	return SUCCESS
