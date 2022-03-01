extends Spatial

var BULLET_SPEED = 20
var BULLET_DAMAGE = 15

const KILL_TIME = 4
var timer = 0
 


func _physics_process(delta):
    var forward_direction = global_transform.basis.z.normalized()
    global_translate(forward_direction * BULLET_SPEED * delta)
    
    timer += delta
    if timer >= KILL_TIME:
        queue_free()



func _on_Area_body_entered(body):
    if body.has_method("bullet_hit"):
        body.bullet_hit(BULLET_DAMAGE)
    queue_free()
