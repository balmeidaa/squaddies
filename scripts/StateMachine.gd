extends Node
class_name StateMachine

var state = null setget set_state
var prev_state = null
var states = {}

onready var parent = get_parent()

func _ready():
    pass

func _physics_process(delta):
    if state != null:
        _state_logic(delta)
        var transition = _get_transition(delta)
        if transition != null:
            set_state(transition)
 
func _state_logic(_delta):
    pass

func _get_transition(_delta):
    return null
    
func _enter_state(new_state, old_state):
    pass

func _exit_state(old_state, new_state):
    pass

func set_state(new_state):
    prev_state = state
    state = new_state
    
    if prev_state != null:
        _exit_state(prev_state, new_state)
    if new_state != null:
        _enter_state(new_state, prev_state)

func add_state(state_name):
    states[state_name] = states.size()
    
