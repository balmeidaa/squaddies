extends "StateMachine.gd"

func _ready():
    add_state("idle")
    add_state("move_to")
    add_state("attack")
    add_state("chase")
    add_state("patrol")
    add_state("reload")
    call_deferred("set_state", states.idle)


func _state_logic(delta):
    if state == states.reload:
        parent._reload()
        
    if state == states.chase:
        parent._move_towards_enemy()

    if state == states.patrol:
        parent._set_patrol_position()

    if state == states.move_to:
        parent._move_to(delta)

    if state == states.attack  and parent._should_attack():
        parent._attack()

 
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
            elif parent._should_chase():
                return states.chase
            elif parent._should_patrol():
                return states.patrol
            else:
                return states.idle
                
        states.patrol:
            if parent._should_move(): 
                return states.move_to
            elif parent._should_reload():
                return states.reload
            elif parent._should_attack():
                return states.attack
            elif parent._should_chase():
                return states.chase
            elif parent._should_patrol():
                return states.patrol
            else:
                return states.idle

        states.chase:
            if parent._should_move():
                return states.move_to
            elif parent._should_attack():
                return states.attack
            elif parent._should_chase():
                return states.chase
            else:
                return states.idle
        
        states.move_to, states.attack:
            if parent._should_reload():
                return states.reload
            elif parent._should_attack():
                return states.attack
            elif parent._should_move():
                return states.move_to
            elif parent._should_chase():
                return states.chase
            else:
                return states.idle



        states.reload:
            if parent._should_reload():
                return states.reload
            elif parent._should_attack():
                return states.attack
            elif parent._should_move():
                return states.move_to
            elif parent._should_chase():
                return states.chase
            else:
                return states.idle
