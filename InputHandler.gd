extends Node
signal invoke_radial_menu
signal order_move
signal player_1_look_at

var target_position: Vector3 setget set_target_position,get_target_position
var squad_selected: int = 0 setget set_squad

func _ready():
    pass # Replace with function body.
    
func player_1_look_at(position:Vector3):
    emit_signal("player_1_look_at", position)

func order_squad():
    #Agregar de que squad estamos referiendp
    emit_signal("order_move")
    
func toggle_radial_menu(position:Vector2):
    emit_signal("invoke_radial_menu", position)

func set_target_position(position:Vector3):
    target_position = position
    
func get_target_position():
    return target_position

func set_squad(squad: int):
    squad_selected = squad
