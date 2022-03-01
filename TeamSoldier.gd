extends KinematicBody

export var speed = 10
export var gravity = -5

var target = null
var velocity = Vector3.ZERO
var distance = null
var contact = false
var enemy_contact = false
var enemy_target = []
onready var anim_player = $AnimationPlayer
onready var logic_control = $LogicControl
onready var debug_label = $Debug.get_node("Viewport/Label")

func _ready():
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

func _attack():
    look_at(enemy_target, Vector3.UP)
    $FirePosition.fire()
    
func _should_move():
    if target != null:
        return true
    else:
        return false

func _should_attack():
     return enemy_contact
          

func _on_Area_body_entered(_body):
    contact = true  
    if target != null and transform.origin.distance_to(target) < 5:
        _stop_moving()
    
func _on_Area_body_exited(body):
    contact = false


func _on_EnemyDetector_body_entered(body):
    if body.is_in_group("enemy"):  
        enemy_contact = true
        enemy_target = body.transform.origin

func _on_EnemyDetector_body_exited(body):
     enemy_contact = false

func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
    #print(animation)
    if debug_label != null:
        debug_label.text = animation
    anim_player.set_animation(animation)
