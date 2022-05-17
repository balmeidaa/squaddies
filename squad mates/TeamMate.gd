extends KinematicBody

var player_index: int
export var speed = 10
var gravity = -5

export var hit_points = 100
var target = null
var velocity = Vector3.ZERO
var distance = null
var follow_player = false
var enemy_contact = false
var enemy_target = []
var reloading = false setget set_reload
var defend = false
var chase_enemy = false

var max_enemy_distance = 30

onready var anim_player = $AnimationPlayer
onready var logic_control = $LogicControl
onready var debug_label = $Debug.get_node("Viewport/Label")

onready var weapon_controller = $WeaponController

func _ready():
    debug_label.text = str(hit_points)
    pass

func _move_to(delta):
    velocity.y += gravity * delta
    if target:
        distance = transform.origin.distance_to(target)
        look_at(target, Vector3.UP)
        rotation.x = 0
        velocity = -transform.basis.z * speed     
        if transform.origin.distance_to(target) < 1.5:
             _stop_moving()
    velocity = move_and_slide(velocity, Vector3.UP)

func _stop_moving():
    target = null
    velocity = Vector3.ZERO

func _move_towards_enemy():
     if _should_chase() and enemy_target.size() > 0:  
        target = enemy_target[0].global_transform.origin


func _attack():
    find_next_target()
    if enemy_target.size() > 0:
        var enemy_position = enemy_target[0].global_transform.origin
        var enemy_distance = global_transform.origin.distance_to(enemy_position)
        
        if enemy_distance <= max_enemy_distance:
            look_at(enemy_position, Vector3.UP)
            if weapon_controller.check_gun_type():
                weapon_controller.release_trigger()
            weapon_controller.hold_trigger()
        else:
            weapon_controller.release_trigger()
            target = enemy_position
            enemy_contact = false
            chase_enemy = true
 
func _reload():
    pass

func _should_reload():
    return reloading
  
func set_reload(reload:bool):
    reloading = reload
     
func find_next_target():
    while (enemy_target.size() > 0 and not is_instance_valid(enemy_target[0])):
        enemy_target.pop_front()
    
func _should_move():
    if target != null:
        return true
    else:
        return false

func _should_attack():
     return enemy_contact
          
func _should_follow():
    return follow_player

func _should_chase():
    return chase_enemy
    
func follow_player_position():
    if _should_follow():
        target = InputHandler.get_player_input(player_index, 'player_position')
        var distance = transform.origin.distance_to(target)   
        if distance != null and distance < 6:
            _stop_moving()
 

       
    
func add_enemy_queue(body):
    var found = enemy_target.find(body)

    if found == -1:
        enemy_target.append(body)

func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
#    if debug_label != null:
#        debug_label.text = str(animation)
    anim_player.set_animation(animation)


func _on_Area_body_entered(_body):
    if target != null and transform.origin.distance_to(target) < 5:
        _stop_moving()
    

func _on_EnemyDetector_body_entered(body):         
    add_enemy_queue(body)
    enemy_contact = true
        

func _on_EnemyDetector_body_exited(body): 
   
    var index_array = enemy_target.find(body)
    # if any else died remove from q
    if index_array >= 0:
        if not is_instance_valid(body) or body.has_method("_is_alive"):
            enemy_target.remove (index_array)
        else:

            chase_enemy = true
         
    if enemy_target.size() == 0:
        chase_enemy = false
        enemy_contact = false

func _recieve_damage(damage):
    hit_points -= damage
    debug_label.text = str(int(round(hit_points)))
    if hit_points <= 0:
        call_deferred("queue_free")
        
func _is_alive():
    if hit_points <= 0:
        return false
    return true
    
