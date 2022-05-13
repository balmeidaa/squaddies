extends "res://items/ItemScript.gd"

export var explosive_damage = 50
onready var explosion_timer = $ExplosionTimer
onready var explosion_area = $ExplosionArea/CollisionShape

func _ready():
    explosion_area.disabled = true


func _on_Area_body_entered(body):
    _on_destroy()


func _on_destroy():
    explosion_area.disabled = false
    explosion_timer.start()
    


func _on_ExplosionArea_body_entered(body):
     if body.has_method("_recieve_damage"):
        body._recieve_damage(explosive_damage)


func _on_ExplosionTimer_timeout():
    queue_free()
