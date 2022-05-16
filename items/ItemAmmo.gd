extends "res://items/ItemExplosiveGeneric.gd"

export var amount_ammo = 20


func _on_pick_up(body):
    if body.has_method("_pick_up_ammo"):
        body._pick_up_ammo(amount_ammo)
        queue_free()

