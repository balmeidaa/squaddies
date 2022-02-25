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
    var move_position = UiRadialMenuHandler.get_target_position()
    for team in self.get_children():
        team.target = move_position
        
