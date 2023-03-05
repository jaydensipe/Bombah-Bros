extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if (!actor.can_throw):
		return FAILURE
	else:
#		actor.set_state("ActionStateMachine", "Throwing")
		return SUCCESS
