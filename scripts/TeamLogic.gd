extends "StateMachine.gd"

func _ready():
    add_state("idle")
    add_state("move_to")
    add_state("attack")
    add_state("follow")
    add_state("reload")
    add_state("defend")
    call_deferred("set_state", states.idle)
    
func _state_logic(delta):
    if state == states.reload:
        parent._reload()
    
    if state == states.follow:
        parent.follow_player_position()

    if state == states.move_to:
        parent._move_to(delta)
    
    if state == states.attack  and parent._should_attack():
        parent._attack()
        
 # target is far away from detection area
    if state == states.attack  and not parent._should_attack():
        parent._move_towards_enemy()
        
    parent._update_animation()
            
func _get_transition(delta):
    
    match(state):
        states.idle:
            if parent._should_move(): 
                return states.move_to
            elif parent._should_reload():
                return states.reload
            elif parent._should_attack():
                return states.attack
            elif parent._should_follow():
                return states.follow
            else:
                return states.idle
                
        states.move_to, states.attack:
            if parent._should_reload():
                return states.reload
            elif parent._should_attack():
                return states.attack
            elif parent._should_move():
                return states.move_to
            elif parent._should_follow():
                return states.follow
            else:
                return states.idle
                
        states.follow:
            if parent._should_attack():
                return states.attack
            elif parent._should_move():
                return states.move_to
            elif parent._should_follow():
                return states.follow
            else:
                return states.idle
                
        states.reload:
            if parent._should_reload():
                return states.reload
            elif parent._should_attack():
                return states.attack
            elif parent._should_move():
                return states.move_to
            elif parent._should_follow():
                return states.follow
            else:
                return states.idle


        
