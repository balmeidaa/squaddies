extends "res://items/ItemScript.gd"

export var heal_amount = 15

func _on_Area_body_entered(body):
    _on_pick_up(body)


func _on_pick_up(body):
    if body.has_method("_heal"):
        body._heal(heal_amount)
        queue_free()
