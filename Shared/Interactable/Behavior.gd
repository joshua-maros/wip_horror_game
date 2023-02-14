extends Node

class_name Behavior

@onready var parent: Interactable = Util.get_parent_interactable(self)

const NULL_PARENT_ERROR = \
	"Behaviors must be the child of an Interactable node."
	
func _ready():
	assert(parent != null, NULL_PARENT_ERROR)
