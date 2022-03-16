extends KinematicBody


export var player_index := 1
var move_right_action
var move_left_action
var move_down_action
var move_up_action
var fire_action

var aim_up
var aim_down
var aim_left
var aim_right

var select_squad_1
var select_squad_2
var select_team 
var squad_menu 

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
onready var cursor = $Cursor
onready var debug_label = $Debug.get_node("Viewport/Label")

onready var marker = $'../Marker'
onready var camera = $'../Camera' as Camera
onready var squad_1 = $'../squad_1' 
onready var squad_2 = $'../squad_2'
var order_attack_active = false

var device_id = 0
var player_teammates

func _ready():
    
    move_right_action = "right_p{n}".format({"n":player_index})
    move_left_action = "left_p{n}".format({"n":player_index})
    move_down_action = "down_p{n}".format({"n":player_index})
    move_up_action = "up_p{n}".format({"n":player_index})
    fire_action = "fire_p{n}".format({"n":player_index})
    
    aim_up = "aim_up_p{n}".format({"n":player_index})
    aim_down = "aim_down_p{n}".format({"n":player_index})
    aim_left = "aim_left_p{n}".format({"n":player_index})
    aim_right = "aim_right_p{n}".format({"n":player_index})
    
    select_squad_1 = "select_squad_1_p{n}".format({"n":player_index})
    select_squad_2 = "select_squad_2_p{n}".format({"n":player_index})
    select_team = "select_team_p{n}".format({"n":player_index})
    squad_menu = "squad_menu_p{n}".format({"n":player_index})
    

    player_teammates = "team_{index}".format({"index":player_index})
    
    InputHandler.connect("order_squad", self, "execute_order_squad")

func _process(delta):
    velocity = Vector3.ZERO
    #check for controller 
    if device_id != -1:
        velocity.x = Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action)
        velocity.z = Input.get_action_strength(move_down_action) - Input.get_action_strength(move_up_action) 
        velocity = velocity.normalized()
    else:
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
    var marker_position
    var position2D
    
    if event.is_action_pressed(fire_action):
        is_attacking = true
    if event.is_action_released(fire_action):
        is_attacking = false
    
    # Player is looking around/aiming
    if event is InputEventMouse:
        position2D = get_viewport().get_mouse_position()
     
       
    elif device_id != -1 and event is InputEventJoypadMotion:
        position2D = get_player_2Dposition()
        position2D.x += (Input.get_action_strength(aim_right) - Input.get_action_strength(aim_left)) * 300
        position2D.y += (Input.get_action_strength(aim_down) - Input.get_action_strength(aim_up)) * 300
    
    if position2D:
        marker_position = get_3Dposition_from_2Dposition(position2D)
        cursor.set_cursor_position(position2D)   
    
    if marker_position:
        player_look_at(marker_position)
    
    ### Squad selection    
    if event.is_action_pressed(select_team):
        InputHandler.set_player_input(player_index, 'squad_selected', 0)      
    if event.is_action_pressed(select_squad_1):
        InputHandler.set_player_input(player_index, 'squad_selected', 1)   
    if event.is_action_pressed(select_squad_2):
        InputHandler.set_player_input(player_index, 'squad_selected', 2)
    
    
    if event.is_action_pressed(squad_menu):
        if device_id != -1:
            InputHandler.toggle_radial_menu(player_index, event.position)
            InputHandler.set_player_input(player_index, 'squad_next_position', marker_position)
            marker.transform.origin = marker_position
        
func set_reload(reload:bool):
    reloading = reload

func _move_status():
    return is_moving

func _attack_status():
    return is_attacking

func player_look_at(position:Vector3):
    print(position)
    position.y = translation.y
    self.look_at(position, Vector3.UP)

            
func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
#    if debug_label != null:
#        debug_label.text = animation
    anim_player.set_animation(animation)


func _on_DistanceTimer_timeout():
    if transform.origin != Vector3.ZERO:
        InputHandler.set_player_input(player_index, 'player_position', transform.origin)

func execute_order_squad(player, order):
    var active_squad = return_active_squad()
    
    if active_squad == null:
        return
        
    if typeof(active_squad) == TYPE_ARRAY:
        get_tree().call_group(player_teammates, order)
    else:
        active_squad.call(order)
        

func return_active_squad():
    var squad_selection = InputHandler.get_player_input(player_index, 'squad_selected')
    var squad_name = "squad_" + String(squad_selection)
    # is_instance_valid
    match squad_name:
        "squad_1":
            if is_instance_valid(squad_1):
                return squad_1
            else:
                return null
        "squad_2":
             if is_instance_valid(squad_2):
                return squad_2
             else:
                return null
        _:
            # just in case if we rescue another teammates we always add them to the squad and give orders
            var team = get_tree().get_nodes_in_group(player_teammates)
            return team # array        


func check_order(player, order):
    match (order):
        "attack":
            order_attack_active = true
        _:
            order_attack_active = false

func _on_MarkedEnemy_body_entered(body):
    if order_attack_active:
        InputHandler.set_player_input(player_index, 'target_enemy', body)
    
func get_3Dposition_from_2Dposition(position2D: Vector2) -> Vector3:
    var dropPlane  = Plane(Vector3(0, 1, 0), 0)
    var from = camera.project_ray_origin(position2D)
    var to = camera.project_ray_normal(position2D)
    return dropPlane.intersects_ray(from,to)

func get_player_2Dposition() -> Vector2:
    return camera.unproject_position(transform.origin)
