extends Node
signal explosion_shake

func explosion(explosion_coords: Vector3):
    emit_signal("explosion_shake", explosion_coords)
