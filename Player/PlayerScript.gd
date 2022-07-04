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
var switch_weapon

var aim_sight
var aim_up
var aim_down
var aim_left
var aim_right

####

export var speed = 10
export var max_health = 120
export var gravity = -5

var current_health = max_health

## STATES
var is_moving = false
var reloading = false setget set_reload, get_reload

onready var anim_player = $AnimationPlayer
onready var logic_control = $LogicControl

onready var debug_label = $Debug.get_node("Viewport/Label")
onready var weapon_controller = $Head/WeaponController


var squads = []
var order_attack_active = false

var device_id = -1
var joypad_motion_factor := .05
var viewport_size
var player_teammates
var position2D = Vector2.ZERO
var motion = Vector2.ZERO
var last_motion = Vector2.ZERO

#animation 
var half_viewport

#camera & mouse settings
export var ACCEL_DEFAULT = 30

export var cam_accel = 40
export var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

func init_player(playerIndex:int, device_id: int = -1):
    self.player_index = playerIndex
    self.device_id = device_id
    
func _ready(): 
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    debug_label.text = str(current_health)

    move_right_action = "right_p{n}".format({"n":player_index})
    move_left_action = "left_p{n}".format({"n":player_index})
    move_down_action = "down_p{n}".format({"n":player_index})
    move_up_action = "up_p{n}".format({"n":player_index})
    fire_action = "fire_p{n}".format({"n":player_index})
    reload_action = "reload_p{n}".format({"n":player_index})
    switch_weapon = "switch_weap_p{n}".format({"n":player_index})
    
    aim_up = "aim_up_p{n}".format({"n":player_index})
    aim_down = "aim_down_p{n}".format({"n":player_index})
    aim_left = "aim_left_p{n}".format({"n":player_index})
    aim_right = "aim_right_p{n}".format({"n":player_index})  
    
    aim_sight = "aim_sight_p{n}".format({"n":player_index})
    
    viewport_size = get_viewport().size
    half_viewport = viewport_size/2

func _input(event):
    #get mouse input for camera rotation
    if event is InputEventMouseMotion:
        rotate_y(deg2rad(-event.relative.x * mouse_sense))
        head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
        head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89)) 

        
func _physics_process(delta):
    direction = Vector3.ZERO
    var h_rot = global_transform.basis.get_euler().y
    var f_input = Input.get_action_strength(move_down_action) - Input.get_action_strength(move_up_action)
    var h_input = Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action)
    direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
    
    snap = -get_floor_normal()
    gravity_vec = Vector3.ZERO
    #make it move
    velocity = velocity.linear_interpolate(direction * speed, ACCEL_DEFAULT * delta)
    movement = velocity + gravity_vec
    
    move_and_slide_with_snap(movement, snap, Vector3.UP)

func _process(delta):
    
    if Engine.get_frames_per_second() > Engine.iterations_per_second:
        camera.set_as_toplevel(true)
        camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
        camera.rotation.y = rotation.y
        camera.rotation.x = head.rotation.x
    else:
        camera.set_as_toplevel(false)
        camera.global_transform = head.global_transform
        
    velocity = Vector3.ZERO
    #check for controller 
    if device_id != -1:
      
       # Aim/ look around
        motion.x = Input.get_action_strength(aim_right) - Input.get_action_strength(aim_left)
        motion.y = Input.get_action_strength(aim_down) - Input.get_action_strength(aim_up)
        motion.normalized()

        position2D.x += lerp(0, (motion.x) * viewport_size.x/2, joypad_motion_factor)
        position2D.y += lerp(0, (motion.y) * viewport_size.y, joypad_motion_factor)

    if Input.is_action_pressed(aim_sight):
        weapon_controller.aim_down()
        
    if Input.is_action_just_released(aim_sight):
        weapon_controller.aim_from_hip()
            
#    if Input.is_action_pressed(reload_action):
#         weapon_controller.reload_weapon()
    
    if Input.is_action_pressed(switch_weapon):
         weapon_controller.switch_weapon()
    
    if velocity.length() > 0:
        is_moving = true
        velocity = velocity.normalized() * speed
        
    else:
        is_moving = false
        
    if Input.is_action_pressed(fire_action):
        weapon_controller.hold_trigger()
   
        
    if check_release_trigger(Input):
        weapon_controller.release_trigger()
  
 
    move_and_slide(velocity)
 

func check_release_trigger(Input):
    return Input.is_action_just_released(fire_action)
        
 
        
func _unhandled_input(event):
    # Player is looking around/aiming using mouse
    if event is InputEventMouse and device_id == -1:
        position2D = get_viewport().get_mouse_position()
    
  
        
func set_reload(reload:bool):
    reloading = reload

func get_reload():
    return reloading

func _move_status():
    return is_moving
 

func player_look_at(position:Vector3):
    position.y = translation.y
    self.look_at(position, Vector3.UP)

            
func _update_animation():
    var keys_array = logic_control.states.keys()
    var key_index = logic_control.state
    var animation = keys_array[key_index] 
#    debug_label.text = animation
#    if debug_label != null:
#        debug_label.text = animation
    anim_player.set_animation(animation)

func is_full_health():
    return (current_health == max_health)
        
func pick_up_weapon(weapon):
    weapon_controller.equip_weapon(weapon)  

func _pick_up_ammo(amount_ammo):
    pass  
    
func _recieve_damage(damage):
    current_health -= int(round(damage))
    debug_label.text = str(current_health)
    if current_health <= 0:
        pass
        #anim dead
