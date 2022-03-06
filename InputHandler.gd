extends Node
signal invoke_radial_menu
signal order_squad
signal player_1_look_at


#Use a dictionare to avoid confusion with player 2 squads and orders
var squad_selected: int = 0 setget set_squad
var squad_position: Vector3 setget set_squad_position,get_squad_position
var player_1_position: Vector3 setget set_player_1_position
var target_enemy: Object setget set_target_enemy, get_target_enemy
    
func player_1_look_at(position:Vector3):
    emit_signal("player_1_look_at", position)

func set_player_1_position(position:Vector3):
    player_1_position = position

func order_squad(order:String):
    emit_signal("order_squad", order)

    
func toggle_radial_menu(position:Vector2):
    emit_signal("invoke_radial_menu", position)

func set_squad_position(position:Vector3):
    squad_position = position
    
func get_squad_position():
    return squad_position

func set_squad(squad: int):
    squad_selected = squad

func set_target_enemy(body:Object):
    target_enemy = body
    
func get_target_enemy():
    return target_enemy
