extends KinematicBody


export var player_index := 1
## Movement/Control
var move_right_action
var move_left_action
var move_down_action
var move_up_action
var fire_action

#pending
var reload_action
var roll_action

var alternate_input = false
var button_x #change weap/ order Attack
var button_y #reload / order go

var button_a #change item/regroup
var button_b #use item/defend


var aim_up
var aim_down
var aim_left
var aim_right

var select_squad_1
var select_squad_2
var select_team 
var squad_menu 

####

export var speed = 10
export var gravity = -5

var target = null
var velocity = Vector3()
var distance = null
## STATES
var contact = false
var is_moving = false
var is_attacking = false
var is_followed = false
var reloading = false setget set_reload, get_reload

onready var anim_player = $AnimationPlayer
onready var logic_control = $LogicControl
onready var cursor = $Cursor
onready var debug_label = $Debug.get_node("Viewport/Label")

onready var marker = $Marker

var camera
onready var squad_1 = $'../squad_1' 
onready var squad_2 = $'../squad_2'
var order_attack_active = false

var device_id = -1
var joypad_motion_factor := .05
var viewport_size
var player_teammates
var position2D = Vector2.ZERO
var marker_position
var motion = Vector2.ZERO
var last_motion = Vector2.ZERO

#animation
onready var soldier_sprite = $Guy as Sprite3D
var half_viewport

func init_player(player_index:int, camera: Camera, device_id: int = -1):
    self.camera = camera
    self.player_index = player_index
    self.device_id = device_id
    
func _ready(): 
#    if position2D:
    position2D = camera.convert_3dpos_to_2dpos(transform.origin)

    marker.set_as_toplevel(true)
    move_right_action = "right_p{n}".format({"n":player_index})
    move_left_action = "left_p{n}".format({"n":player_index})
    move_down_action = "down_p{n}".format({"n":player_index})
    move_up_action = "up_p{n}".format({"n":player_index})
    fire_action = "fire_p{n}".format({"n":player_index})
    reload_action = "reload_p{n}".format({"n":player_index})
    
    aim_up = "aim_up_p{n}".format({"n":player_index})
    aim_down = "aim_down_p{n}".format({"n":player_index})
    aim_left = "aim_left_p{n}".format({"n":player_index})
    aim_right = "aim_right_p{n}".format({"n":player_index})
    
    select_squad_1 = "select_squad_1_p{n}".format({"n":player_index})
    select_squad_2 = "select_squad_2_p{n}".format({"n":player_index})
    select_team = "select_team_p{n}".format({"n":player_index})
    squad_menu = "squad_menu_p{n}".format({"n":player_index})
    
    button_x = "x_p{n}".format({"n":player_index})
    button_y = "y_p{n}".format({"n":player_index})
    button_a = "a_p{n}".format({"n":player_index})
    button_b = "b_p{n}".format({"n":player_index})
    
    viewport_size = get_viewport().size
    half_viewport = viewport_size/2
    player_teammates = "team_{index}".format({"index":player_index})
    
    InputHandler.connect("order_squad", self, "execute_order_squad")

func _process(delta):
    velocity = Vector3.ZERO
    #check for controller 
    if device_id != -1:
        # Character movement
        velocity.x = Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action)
        velocity.z = Input.get_action_strength(move_down_action) - Input.get_action_strength(move_up_action) 
        velocity = velocity.normalized()
       # Aim/ look around
        motion.x = Input.get_action_strength(aim_right) - Input.get_action_strength(aim_left)
        motion.y = Input.get_action_strength(aim_down) - Input.get_action_strength(aim_up)
        motion.normalized()

        position2D.x += lerp(0, (motion.x) * viewport_size.x/2, joypad_motion_factor)
        position2D.y += lerp(0, (motion.y) * viewport_size.y, joypad_motion_factor)
        
         #actions
        if not alternate_input:
    
            if Input.is_action_pressed(button_x):
                print('X')
                pass #change weap
            if Input.is_action_pressed(button_y):
                print('Y')
                $FirePosition.reload_weapon() #Change this later
            if Input.is_action_pressed(button_a):
                print('A')
                pass #change item
            if Input.is_action_pressed(button_b):
                print('B')
                pass #use item
            
    else:
        #movement
        if Input.is_action_pressed(move_right_action):
            velocity.x += 1
        if Input.is_action_pressed(move_left_action):
            velocity.x -= 1
        if Input.is_action_pressed(move_down_action):
            velocity.z += 1
        if Input.is_action_pressed(move_up_action):
            velocity.z -= 1
            
    if Input.is_action_pressed(reload_action):
         $FirePosition.reload_weapon()

        
    if velocity.length() > 0:
        is_moving = true
        velocity = velocity.normalized() * speed
    else:
        is_moving = false
        
    if Input.is_action_pressed(fire_action):
        is_attacking = true
    if Input.is_action_just_released(fire_action):
        is_attacking = false

    if is_attacking:
        $FirePosition.fire()
  
    if position2D != Vector2.ZERO:
        marker_position = camera.convert_2dpos_to_3dpos(position2D)
        cursor.set_cursor_position(position2D)  
        camera.follow(transform.origin, position2D) 
    
    if marker_position:
        player_look_at(marker_position)
        
    flip_sprite()    
    move_and_slide(velocity)
 
func flip_sprite():
    if position2D.x < half_viewport.x:
        soldier_sprite.flip_h = true
    elif position2D.x > half_viewport.x:
        soldier_sprite.flip_h = false
        
        
func _unhandled_input(event):

    # Player is looking around/aiming using mouse
    if event is InputEventMouse and device_id == -1:
        position2D = get_viewport().get_mouse_position()
    
        ### Squad selection    
    if Input.is_action_pressed(select_team):
        InputHandler.set_player_input(player_index, 'squad_selected', 0)      
    if Input.is_action_pressed(select_squad_1):
        InputHandler.set_player_input(player_index, 'squad_selected', 1)   
    if Input.is_action_pressed(select_squad_2):
        InputHandler.set_player_input(player_index, 'squad_selected', 2)
  
    ### Squad Order
    if Input.is_action_pressed(squad_menu):
        if device_id > -1:
            alternate_input = !alternate_input 

        InputHandler.toggle_radial_menu(player_index, position2D)
        InputHandler.set_player_input(player_index, 'squad_next_position', marker_position)
        marker.transform.origin = marker_position
    

  
        
func set_reload(reload:bool):
    reloading = reload

func get_reload():
    return reloading

func _move_status():
    return is_moving

func _attack_status():
    return is_attacking

func player_look_at(position:Vector3):
    position.y = translation.y
    self.look_at(position, Vector3.UP)

            
func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
    debug_label.text = animation
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
    

