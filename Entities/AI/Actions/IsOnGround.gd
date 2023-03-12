extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.is_on_floor():
		return SUCCESS
	else:
		actor.set_state("StateMachine", "Air")
		return FAILURE
