extends KinematicBody

export var speed = 10
export var gravity = -5

var target = null
var velocity = Vector3()
var distance = null
var contact = false
var is_moving = false
var is_attacking = false
var is_followed = false
var reloading = false setget set_reload
onready var anim_player = $AnimationPlayer
onready var logic_control = $LogicControl
onready var debug_label = $Debug.get_node("Viewport/Label")

func _ready():
    InputHandler.connect("player_1_look_at", self, "player_look_at")
    
func _process(delta):
    velocity = Vector3.ZERO
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.z += 1
    if Input.is_action_pressed("ui_up"):
        velocity.z -= 1
    if velocity.length() > 0:
        is_moving = true
        velocity = velocity.normalized() * speed
    else:
        is_moving = false
    
    if is_attacking:
        $FirePosition.fire()
    move_and_slide(velocity)

func _unhandled_input(event):
    if event.is_action_pressed("player_fire_1"):
        is_attacking = true
    if event.is_action_released("player_fire_1"):
        is_attacking = false
        
func set_reload(reload:bool):
    reloading = reload

func _move_status():
    return is_moving

func _attack_status():
    return is_attacking

func player_look_at(position:Vector3):
    self.look_at(position, Vector3.UP)

            
func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
    if debug_label != null:
        debug_label.text = animation
    anim_player.set_animation(animation)


func _on_DistanceTimer_timeout():
    if transform.origin != Vector3.ZERO:
        InputHandler.set_player_1_position(transform.origin)

