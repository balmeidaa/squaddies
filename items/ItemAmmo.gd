extends "res://items/ItemExplosiveGeneric.gd"

export var ammo_mags = 2

func _on_pick_up(body):
    if body.has_method("_pick_up_ammo"):
        if body._pick_up_ammo(ammo_mags):
            queue_free()

func _on_Area_body_entered(body):
    _on_pick_up(body)
