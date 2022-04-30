extends "StateMachine.gd"
#add use item
func _ready():
    add_state("idle")
    add_state("move_to")

    add_state("reload")
    call_deferred("set_state", states.idle)
    
func _state_logic(delta):
    parent._update_animation()
            
func _get_transition(delta):
    match(state):
        states.idle:
            if parent._move_status(): 
                return states.move_to

            elif parent.get_reload():
                return states.reload
            else:
                return states.idle
        states.move_to,states.reload:

            if parent._move_status():
                return states.move_to
            elif parent.get_reload():
                return states.reload
            else:
                return states.idle


        
