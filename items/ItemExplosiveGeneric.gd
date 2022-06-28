extends "res://items/ItemScript.gd"

export var max_explosion_damage = 100
export var distance_damage_multiplier = 6
onready var explosion_timer = $ExplosionTimer
onready var explosion_area = $ExplosionArea
onready var explosion_collision = $ExplosionArea/CollisionShape
onready var sprite3d = $Sprite3D
onready var collision_shape = $CollisionShape
onready var delay_explosion = $DelayExplosion
const explosion_vfx = preload("res://vfx/explosion.tscn") 
var is_destroyed = false

 

func _on_destroy():
    
    is_destroyed = true
    sprite3d.hide()
    collision_shape.disabled = true
    explosion_timer.start()
    $VfxTimer.start()
    var explosion = explosion_vfx.instance()
    add_child(explosion)
          
    for body in explosion_area.get_overlapping_bodies():  
        if body.has_method("_recieve_damage"):
            var explosion_damage = max_explosion_damage - transform.origin.distance_to(body.transform.origin) * distance_damage_multiplier
            body._recieve_damage(explosion_damage)
        elif body.has_method("_on_destroy") and body.has_method("is_destroyed"):
            if not body.is_destroyed():
                body._on_destroy()

func is_destroyed():
    return is_destroyed    
    

func _on_VfxTimer_timeout():
    queue_free()

func _on_ExplosionTimer_timeout():
    explosion_collision.disabled = true
    
