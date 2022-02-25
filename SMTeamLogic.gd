extends "res://StateMachine.gd"

func _ready():
    add_state("idle")
    add_state("move_to")
    add_state("attack")
    add_state("moving_attack")
    add_state("reload")

