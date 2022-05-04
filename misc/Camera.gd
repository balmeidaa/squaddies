extends Camera

export var shift_duration := .9
export var max_offset_factor := 0.02
export var min_distance := 3
export var max_distance := 17.5
onready var tween = $ShiftTween

var shift := Vector2.ZERO
var following_player = null
var camera_position:Vector3
var camera_offset:Vector3
var viewport_rect

var old_player_pos = Vector3.ZERO
var current_player_pos =  null

var offset_res
var align_first = false

func _ready():
     viewport_rect = -1 * get_viewport().size/2

func _process(delta):
    if not align_first:
        align_first = true
        camera_position.x = following_player.translation.x
    
    if following_player != null:
        current_player_pos = following_player.translation
        
        if  current_player_pos !=  old_player_pos and not tween.is_active():        
                camera_position = get_global_transform().origin 
                camera_offset = camera_position + (current_player_pos - old_player_pos)
                old_player_pos = current_player_pos
                tween_camera()


func follow(player_position: Vector3, cursor_position: Vector2):
    var distance = player_position.distance_to(camera_position)

    if distance >= min_distance:
        var player_pos_2d = convert_3dpos_to_2dpos(player_position)
        
        offset_res = (cursor_position + player_pos_2d)/2 + viewport_rect
        camera_offset = camera_position
        camera_offset.x += offset_res.x * max_offset_factor
        camera_offset.z += offset_res.y * max_offset_factor
        tween_camera()
    
    
    
func assign_player(player):    
    following_player = player

 
func tween_camera():
    tween.interpolate_property(self, "translation", camera_position, camera_offset, 
                                shift_duration, Tween.TRANS_LINEAR)
    tween.start()


func convert_2dpos_to_3dpos(position2D: Vector2) -> Vector3:
    var dropPlane  = Plane(Vector3(0, 1, 0), 0)
    var from = self.project_ray_origin(position2D)
    var to = self.project_ray_normal(position2D)
    var res = dropPlane.intersects_ray(from,to)
    return res



func convert_3dpos_to_2dpos(origin_2d) -> Vector2:
    return self.unproject_position(origin_2d)
    


