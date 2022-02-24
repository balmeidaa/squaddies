extends AnimationPlayer


var squad_states:={
    "idle":["idle","move_to","fire","moving_fire"],
    "move_to":["idle","moving_fire","fire"],
    "moving_fire":["idle","move_to","fire"],
    "fire":["idle","moving_fire","move_to"]
   }

var animation_speeds = {
    "idle":1,
    "move_to":1,
    "fire":0.2,
    "moving_fire":1.5
}

var current_state: String
var callback_function = null

func _ready():

    current_state = "idle"
    set_animation("idle")
    connect("animation_finished", self, "animation_ended")

func set_animation(animation_name):
    if animation_name == current_state:
        #print ("AnimationPlayer_Manager.gd -- WARNING: animation is already ", animation_name)
        return true


    if has_animation(animation_name):
        if current_state != null:
            var possible_animations = squad_states[current_state]
            if animation_name in possible_animations:
                current_state = animation_name
                play(animation_name, -1, animation_speeds[animation_name])
                return true
            else:
                print ("AnimationPlayer_Manager.gd -- WARNING: Cannot change to ", animation_name, " from ", current_state)
                return false
        else:
            current_state = animation_name
            play(animation_name, -1, animation_speeds[animation_name])
            return true
    return false


func animation_ended(anim_name):
    match(current_state):
        "idle":
            pass
        "move_to":
            pass

func animation_callback():
    if callback_function == null:
        print ("AnimationPlayer_Manager.gd -- WARNING: No callback function for the animation to call!")
    else:
        callback_function.call_func()

 
   
