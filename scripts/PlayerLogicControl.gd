extends "StateMachine.gd"

func _ready():
    add_state("idle")
    add_state("move_to")
    add_state("moving_attack")
    add_state("attack")
    add_state("reload")
    call_deferred("set_state", states.idle)
    
func _state_logic(delta):
    pass
#    if states.move_to and parent._move_status():
#        parent._move_to(delta)
#
#    if states.attack  and parent._attack_status():
#        parent._attack()
#
#    if states.idle:
#        pass
    
    parent._update_animation()
            
func _get_transition(delta):
    match(state):
        states.idle:
            if parent._move_status(): 
                return states.move_to
            elif parent._attack_status():
                return states.attack
            else:
                return states.idle
        states.move_to,states.attack:
            if parent._move_status() and parent._attack_status():
                return states.moving_attack
            elif parent._move_status():
                return states.move_to
            elif parent._attack_status():
                return states.attack
            else:
                return states.idle


        
