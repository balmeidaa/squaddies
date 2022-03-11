extends Spatial

var resolution

export(PackedScene) var dummy
const squad_factory = preload("Squad.tscn") #preload("Squad.tscn")
var squad_1
var squad_2

onready var collison_marker = $Marker/MarkedEnemy/CollisionShape

var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    squad_1 = squad_factory.instance()
    squad_2 = squad_factory.instance()
    squad_1.set_player_index(1)
    squad_2.set_player_index(1)
    add_child(squad_1)
    add_child(squad_2)
   

  
    #$Debugger.add_property(InputHandler, "squad_selected", "")



func _unhandled_input(event):
    #Debug purposes
    if event.is_action_pressed("ui_accept"):
        var new_dummy = dummy.instance()
        new_dummy.global_transform.origin = Vector3(rng.randf_range(-10.0, 10.0),0.02,rng.randf_range(-10.0, 10.0))
        add_child(new_dummy)
    
