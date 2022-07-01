extends Spatial

onready var player = get_parent()


var camrot_h = 0
var camrot_v = 0
var cam_v_max = 75
var cam_v_min = -55
var h_sensitivity = 0.1
var v_sensitivity = 0.1
var h_acceleration = 10
var v_acceleration = 10

onready var camera = $OuterGimbal/InnerGimbal/Camera
onready var mouse_delay = $MouseDelay
onready var h = $OuterGimbal
onready var v = $OuterGimbal/InnerGimbal

export (float, 0.0, 2.0) var rotation_speed = PI/2


    
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    camera.add_exception(get_parent())



func _input(event):
    if event is InputEventMouseMotion:
        mouse_delay.start()
        camrot_h += -event.relative.x * h_sensitivity
        camrot_v += event.relative.y * v_sensitivity
        
func _physics_process(delta):
    
    camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
    
    var mesh_front = player.global_transform.basis.z
    var rot_speed_multiplier = 0.15 #reduce this to make the rotation radius larger
    var auto_rotate_speed =  (PI - mesh_front.angle_to(h.global_transform.basis.z)) * get_parent().velocity.length() * rot_speed_multiplier
    
    if mouse_delay.is_stopped():
        #FOLLOW CAMERA
        h.rotation.y = lerp_angle(h.rotation.y, player.global_transform.basis.get_euler().y, delta * auto_rotate_speed)
        camrot_h = h.rotation_degrees.y
    else:
        #MOUSE CAMERA
        h.rotation_degrees.y = lerp(h.rotation_degrees.y, camrot_h, delta * h_acceleration)
    
    v.rotation_degrees.x = lerp(v.rotation_degrees.x, camrot_v, delta * v_acceleration)
