extends "res://items/ItemScript.gd"

export var grenade = 1

func _on_pick_up(body):
    if body.has_method("_pick_up_grenade"):
        if body._pick_up_grenade(grenade):
            queue_free()

func _on_Area_body_entered(body):
    _on_pick_up(body)

 
