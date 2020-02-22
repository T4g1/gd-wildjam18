"""
Finite State Machine controller
States only change during after process
"""
extends Node
class_name FSM

var sprite : AnimatedSprite = null
var current_state : Node = null

"""
Pause physics_process and process until the transition is over
"""
var transition = false

export (NodePath) var INITIAL_STATE
export (bool) var debug = false


func _ready() -> void:
	"""
	Initialize the FSM
	"""
	for node in get_children():
		node.fsm = self
		node.owner = get_owner()

	assert(INITIAL_STATE)
	_set_state(get_node(INITIAL_STATE))


func set_state(state_name: String) -> void:
	"""
	Set the state to transition to
	"""
	transition = true

	var next_state = find_node(state_name)
	assert(next_state)
	_set_state(next_state)

	transition = false


func _set_state(new_state: Node) -> void:
	"""
	Set the active state and activate transition
	"""
	if current_state != null:
		current_state.on_exit()

	current_state = new_state

	if debug:
		print("%s: %s" % [owner.name, new_state.name])

	new_state.on_enter()


func disable() -> void:
	"""
	Disable processing
	"""
	current_state.disable()


func enable() -> void:
	"""
	Enable processing
	"""
	current_state.enable()
