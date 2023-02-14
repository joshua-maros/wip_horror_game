extends ContainerBehavior

func can_take(holdable: HoldableBehavior):
	print(holdable)
	return holdable.label == "Carrot"
