extends AnimationPlayer

 
func set_animation(animation_name):
    if animation_name == current_animation:
        return true
    if has_animation(animation_name):
        play(animation_name)
        return true
    else:
        print ("AnimationPlayer_Manager.gd -- WARNING: animation no found")
        return false
       
 

 
   
