extends Spatial

var BULLET_SPEED = 30
var BULLET_DAMAGE = 15

var KILL_TIME = 4
var timer = 0
 
func init_bullet(damage,speed,fly_time):
    BULLET_DAMAGE = damage
    BULLET_SPEED = speed
    KILL_TIME = fly_time
    

func _physics_process(delta):
    var forward_direction = global_transform.basis.z.normalized()
    global_translate(forward_direction * BULLET_SPEED * delta)
    
    timer += delta
    if timer >= KILL_TIME:
        queue_free()



func _on_Area_body_entered(body):
    if body.has_method("_recieve_damage"):
        body._recieve_damage(BULLET_DAMAGE)
    elif body.has_method("_on_destroy"):
        body._on_destroy()
    queue_free()
