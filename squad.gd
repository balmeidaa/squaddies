extends Node
const radius = 500.0
const min_dist = 10
const y = 0.019

func _ready():
    randomize()
    for team in self.get_children():
        var x = rand_range(-min_dist, min_dist)
        var z = rand_range(-min_dist, min_dist)
        team.global_transform.origin = Vector3(x,y,z)

func move_squad():
    var move_position = InputHandler.get_squad_position()
    for team in self.get_children():
        team.target = move_position
        
func regroup():
    for team in self.get_children():
        team.follow_player = true

func attack():
    var enemy_target = InputHandler.get_target_enemy()
    if enemy_target:
        for team in self.get_children():
            team.add_enemy_queue(enemy_target)
        InputHandler.set_target_enemy(null)
    else:
        move_squad()
