extends "res://items/ItemScript.gd"

export var amount_ammo = 20
export var explosive_damage = 30
onready var explosion_timer = $ExplosionTimer
onready var explosion_area = $ExplosionArea/CollisionShape

func _ready():
    explosion_area.disabled = true



func _on_pick_up(body):
    if body.has_method("_pick_up_ammo"):
        body._pick_up_ammo(amount_ammo)
        queue_free()

func _on_Area_body_entered(body):
    if body.is_in_group("player"):
        _on_pick_up(body)
    elif  body.is_in_group("bullet"):
        _on_destroy()


func _on_destroy():
    explosion_area.disabled = false
    explosion_timer.start()
    

func _on_ExplosionArea_body_entered(body):
     if body.has_method("_recieve_damage"):
        body._recieve_damage(explosive_damage)


func _on_ExplosionTimer_timeout():
    queue_free()
