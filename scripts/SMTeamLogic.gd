extends "StateMachine.gd"

func _ready():
    add_state("idle")
    add_state("move_to")
    add_state("attack")
    add_state("reload")
    call_deferred("set_state", states.idle)
    
func _state_logic(delta):
    
    if states.move_to and parent._should_move():
        parent._move_to(delta)
    
    if states.attack  and parent._should_attack():
        parent._attack()
        
    if states.idle:
        parent._stop_moving()
    
    parent._update_animation()
            
func _get_transition(delta):
    match(state):
        states.idle:
            if parent._should_move(): 
                return states.move_to
            elif parent._should_attack():
                return states.attack
            else:
                return states.idle
        states.move_to,states.attack:
            if parent._should_attack():
                return states.attack
            elif parent._should_move():
                return states.move_to
            else:
                return states.idle


        
