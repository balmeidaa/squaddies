extends Node
signal invoke_radial_menu
signal order_squad
signal player_1_look_at


#Use a dictionare to avoid confusion with player 2 squads and orders
var squad_selected: int = 0 
var squad_position: Vector3 
var player_1_position: Vector3 
var target_enemy: Object 


func order_squad(player_index: int, order:String):
    emit_signal("order_squad", player_index, order)

func toggle_radial_menu(position:Vector2):
    emit_signal("invoke_radial_menu", position)

func set_squad_position(player_index: int, position:Vector3):
    squad_position = position
    
func get_squad_position(player_index: int):
    return squad_position

func set_squad(player_index: int, squad: int):
    squad_selected = squad

func set_target_enemy(player_index: int, body:Object):
    target_enemy = body
    
func get_target_enemy(player_index: int):
    return target_enemy


# TBD
func player_1_look_at(position:Vector3):
    emit_signal("player_1_look_at", position)

func set_player_1_position(position:Vector3):
    player_1_position = position



    
