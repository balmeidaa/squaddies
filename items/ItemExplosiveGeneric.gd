extends "res://items/ItemScript.gd"

export var max_explosion_damage = 100
onready var explosion_timer = $ExplosionTimer
onready var explosion_area = $ExplosionArea/CollisionShape
onready var sprite3d = $Sprite3D
onready var collision_shape = $CollisionShape
const explosion_vfx = preload("res://vfx/explosion.tscn") 



func _ready():
    explosion_area.disabled = true

func _on_destroy():
    sprite3d.hide()
    collision_shape.disabled = true
    explosion_area.disabled = false
    explosion_timer.start()
    var explosion = explosion_vfx.instance()
    add_child(explosion)


func _on_ExplosionArea_body_entered(body):
     print($ExplosionArea.get_overlapping_bodies())
    
     if body.has_method("_recieve_damage"):
        var explosion_damage = max_explosion_damage - transform.origin.distance_to(body.transform.origin) * 6
        body._recieve_damage(explosion_damage)
     elif body.has_method("_on_destroy"):
        print(body)
        body._on_destroy()


func _on_ExplosionTimer_timeout():
    queue_free()
