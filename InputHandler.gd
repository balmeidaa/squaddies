extends Node
signal invoke_radial_menu
signal order_squad

var player_input_data = {
        'player_1':{
            'squad_selected': 0,
            'squad_next_position': Vector3(),
            'player_position': Vector3(),
            'target_enemy': Object()
           },
        'player_2':{
            'squad_selected': 0,
            'squad_next_position': Vector3(),
            'player_position': Vector3(),
            'target_enemy': Object()
           }
   }

func order_squad(player_index: int, order:String):
    emit_signal("order_squad", player_index, order)

func toggle_radial_menu(player_index: int, position:Vector2):
    emit_signal("invoke_radial_menu", player_index, position)

func set_player_input(player_index: int, property: String, value):
    var active_player = "player_{n}".format({"n":player_index})
    player_input_data[active_player][property] = value

func get_player_input(player_index: int, property: String):
    var active_player = "player_{n}".format({"n":player_index})
    return player_input_data[active_player][property]
