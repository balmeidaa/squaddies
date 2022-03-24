extends Camera

export var shift_duration := .9
export var max_offset_factor := 0.02
onready var tween = $ShiftTween
var shift := Vector2.ZERO
var camera_position:Vector3
var camera_offset:Vector3

func _process(delta):
    camera_position = get_global_transform().origin 


func follow(player_position: Vector3, cursor_position: Vector2):
    var offset_res
    var player_pos_2d = convert_3dpos_to_2dpos(player_position)
    
    var viewport_rect = -1 * get_viewport().size/2
    
    offset_res = (cursor_position + player_pos_2d)/2 + viewport_rect
    camera_offset = camera_position
    camera_offset.x += offset_res.x * max_offset_factor
    camera_offset.z += offset_res.y * max_offset_factor

    tween.interpolate_property(self, "translation", camera_position, camera_offset, 
                            shift_duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
    tween.start()
    
    
 
func follow_player(player_position: Vector3):
    tween.interpolate_property(self, "translation", camera_position, player_position, 
                            shift_duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
    tween.start()


func follow_cursor(cursor_position: Vector2):
    
    var camera_offset = camera_position
    var viewport_rect = -1 * get_viewport().size/2
    
    cursor_position += viewport_rect
    camera_offset.x += cursor_position.x * max_offset_factor
    camera_offset.z += cursor_position.y * max_offset_factor

    tween.interpolate_property(self, "translation", camera_position, camera_offset, 
                            shift_duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
    tween.start()



func convert_2dpos_to_3dpos(position2D: Vector2) -> Vector3:
    var dropPlane  = Plane(Vector3(0, 1, 0), 0)
    var from = self.project_ray_origin(position2D)
    var to = self.project_ray_normal(position2D)
    var res = dropPlane.intersects_ray(from,to)
    return res



func convert_3dpos_to_2dpos(origin_2d) -> Vector2:
    return self.unproject_position(origin_2d)
    


