extends Node
const radius = 500.0
const min_dist = 10
const y = 0.019
var player_index : int
var player_teammates : String

func _ready():
    randomize()
    for team in self.get_children():
        var x = rand_range(-min_dist, min_dist)
        var z = rand_range(-min_dist, min_dist)
        team.global_transform.origin = Vector3(x,y,z)

func set_up_squad(player):
    var player_teammates = "team_{index}".format({"index":player})
    add_to_group(player_teammates)
    player_index = player
    for team in self.get_children():
        team.player_index = player_index
    

func move_squad():
    var move_position = InputHandler.get_player_input(player_index, 'squad_next_position')
    for team in self.get_children():
        team.follow_player = false
        team.target = move_position
        team.defend = false   
        
func regroup():
    for team in self.get_children():
        team.follow_player = true
        team.defend = false
        
func defend():
    for team in self.get_children():
        team.defend = true        

func attack():
    #Debugear esta funcion
    var enemy_target = InputHandler.get_player_input(player_index, 'target_enemy')
    if enemy_target:
        for team in self.get_children():
            team.follow_player = false
            team.defend = false
            team.add_enemy_queue(enemy_target)
        InputHandler.set_target_enemy(1,null)
    else:
        move_squad()
