extends Node

signal health
signal ammo
signal grenade


func health_signal(player_index, current_health):
    emit_signal("health", player_index, current_health)

func grenade_signal(player_index, grenade_stock):
    emit_signal("grenade", player_index, grenade_stock)
    
func ammo_signal(player_index, in_mag, available):
    emit_signal("ammo", player_index, in_mag, available)
