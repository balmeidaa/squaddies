extends KinematicBody


export var player_index := 1
var move_right_action
var move_left_action
var move_down_action
var move_up_action
var fire_action

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

onready var marker = $'../Marker'
onready var camera = $'../Camera' as Camera
onready var squad_1 = $'../squad_1' 
onready var squad_2 = $'../squad_2'
var order_attack_active = false
var position3D

func _ready():
    move_right_action = "right_p{n}".format({"n":player_index})
    move_left_action = "left_p{n}".format({"n":player_index})
    move_down_action = "down_p{n}".format({"n":player_index})
    move_up_action = "up_p{n}".format({"n":player_index})
    fire_action = "fire_p{n}".format({"n":player_index})
    
    InputHandler.connect("player_1_look_at", self, "player_look_at")
    InputHandler.connect("order_squad", self, "execute_order_squad")
    InputHandler.connect("order_squad", self, "check_order")
    
func _process(delta):
    velocity = Vector3.ZERO
    if Input.is_action_pressed(move_right_action):
        velocity.x += 1
    if Input.is_action_pressed(move_left_action):
        velocity.x -= 1
    if Input.is_action_pressed(move_down_action):
        velocity.z += 1
    if Input.is_action_pressed(move_up_action):
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
    var mouse_position = get_mouse_3Dposition()
    
    if event.is_action_pressed(fire_action):
        is_attacking = true
    if event.is_action_released(fire_action):
        is_attacking = false
    
    if event is InputEventMouseMotion:
        if mouse_position:
            InputHandler.player_1_look_at(mouse_position)
    if event.is_action_pressed("select_squad_1_p1"):
        InputHandler.set_squad(player_index, 1)
    if event.is_action_pressed("select_squad_2_p1"):
        InputHandler.set_squad(player_index ,2)
    if event.is_action_pressed("select_team_p1"):
        InputHandler.set_squad(player_index, 0)
    if event.is_action_pressed("squad_menu_p1"):
        InputHandler.toggle_radial_menu(event.position)
        InputHandler.set_squad_position(player_index, mouse_position)
        marker.transform.origin = mouse_position
        
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

func execute_order_squad(player, order):
    var active_squad = return_active_squad()
    if typeof(active_squad) == TYPE_ARRAY:
        for squad in active_squad:
            squad.call(order)
    else:
        active_squad.call(order)
        

func return_active_squad():
    var squad_name = "squad_" + String(InputHandler.squad_selected)
    
    match squad_name:
        "squad_1":
            return squad_1
        "squad_2":
            return squad_2
        _:
            var team = get_tree().get_nodes_in_group("team")
            return team # array        


func check_order(player, order):
    match (order):
        "attack":
            order_attack_active = true
        _:
            order_attack_active = false


func _on_MarkedEnemy_body_entered(body):
    if order_attack_active:
        InputHandler.set_target_enemy(player_index, body)
    
func get_mouse_3Dposition() -> Vector3:
    var position2D = get_viewport().get_mouse_position()
    var dropPlane  = Plane(Vector3(0, 1, 0), 0)
    var from = camera.project_ray_origin(position2D)
    var to = camera.project_ray_normal(position2D)
    position3D = dropPlane.intersects_ray(from,to)
    return position3D
