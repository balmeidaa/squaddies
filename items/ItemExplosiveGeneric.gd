extends "res://items/ItemScript.gd"

export var max_explosion_damage = 100
onready var explosion_timer = $ExplosionTimer
onready var explosion_area = $ExplosionArea/CollisionShape
const explosion_vfx = preload("res://vfx/explosion.tscn") 



func _ready():
    explosion_area.disabled = true


func _on_destroy():
    explosion_area.disabled = false
    explosion_timer.start()
    var explosion = explosion_vfx.instance()
    add_child(explosion)


func _on_ExplosionArea_body_entered(body):
     if body.has_method("_recieve_damage"):
        var explosion_damage = max_explosion_damage - transform.origin.distance_to(body.transform.origin) * 6
        body._recieve_damage(explosion_damage)


func _on_ExplosionTimer_timeout():
    explosion_area.disabled = true
    queue_free()
