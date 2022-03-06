extends KinematicBody

export var speed = 10
export var gravity = -5

var target = null
var velocity = Vector3.ZERO
var distance = null
var follow_player = false
var enemy_contact = false
var enemy_target = []
onready var anim_player = $AnimationPlayer
onready var logic_control = $LogicControl
onready var debug_label = $Debug.get_node("Viewport/Label")

func _ready():
    InputHandler.connect("order_squad", self, "check_order")

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
    if not enemy_contact and enemy_target.size() > 0: 
        target = enemy_target[0].global_transform.origin
        print(target)

func _attack():
    find_next_target()
    if enemy_target.size() > 0:
        var enemy_position = enemy_target[0].global_transform.origin
        look_at(enemy_position, Vector3.UP)
        $FirePosition.fire()
        
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

func follow_player_position():
    if _should_follow():
        target = InputHandler.player_1_position
        var distance = transform.origin.distance_to(target)   
        if distance != null and distance < 6:
            _stop_moving()
 
func check_order(order):
    match (order):
        "regroup":
            follow_player = true
        _:
            follow_player = false
       
func add_enemy_queue(body):
    if enemy_target.find(body) == -1:
        enemy_target.append(body)
        return true
    
    return false

func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
    if debug_label != null:
        debug_label.text = animation
    anim_player.set_animation(animation)


func _on_Area_body_entered(_body):
    if target != null and transform.origin.distance_to(target) < 5:
        _stop_moving()
    

func _on_EnemyDetector_body_entered(body):
    if body.is_in_group("enemy"):           
        enemy_contact = add_enemy_queue(body)
        

func _on_EnemyDetector_body_exited(body):
    
    var index_array = enemy_target.find(body)
    if body.is_in_group("enemy") and index_array >= 0:
        enemy_target.remove (index_array)
         
    if enemy_target.size() == 0:    
        enemy_contact = false
