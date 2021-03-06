extends Spatial

var resolution

export(PackedScene) var dummy
const squad_factory = preload("squad mates/Squad.tscn")
const camera_factory = preload("misc/Camera.tscn")
const player_factory = preload("squad mates/PlayerSoldier.tscn")


var players = []

onready var screen = $Control/Screen

var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()   
    screen.get_node("Viewport2").hide()
    Input.connect("joy_connection_changed", self, "_joy_connection_changed")
    
    var player = add_new_player(1,-1)
    add_teammates(player, 1)
 
#    $Debugger.add_property($Player/Camera, "dis", "")
#    $Debugger.add_property($Player/Cursor, "position", "")
#    $Debugger.add_property($Player, "motion", "")

func add_new_player(player_index, device_id:int = -1):
    var new_player = player_factory.instance()
    var camera = camera_factory.instance()
    var cam_name = "camera_p{n}".format({"n":player_index})
    camera.set_name(cam_name)
    players.append(new_player)
    camera.assign_player(new_player)
    new_player.init_player(player_index, camera, device_id)
    new_player.transform.origin = Vector3(-3*player_index,0.02,player_index)
    screen.get_node("Viewport{n}/Viewport".format({"n":player_index})).add_child(camera,true)
    screen.get_node("Viewport{n}/Viewport".format({"n":player_index})).add_child(new_player)
    return new_player
    
func add_teammates(player, player_index):
    
    for i in range(2):
        var squad_name = "squad_{index}_p{n}".format({"index":i ,"n":player_index})
        var squad = squad_factory.instance()
        squad.name = squad_name
        squad.set_up_squad(player_index)
        add_child(squad, true)
        player.add_squad(squad)



func _joy_connection_changed(device_id:int, connected:bool):
    plug_controller()



func plug_controller():

    if Input.get_connected_joypads().size() == 1:
        add_teammates(add_new_player(1,0), 1)
        
    elif  Input.get_connected_joypads().size() == 2:
        add_teammates(add_new_player(2,1),2)
        screen.get_node("Viewport2").show()


func _unhandled_input(event):
    #Debug purposes
    if event.is_action_pressed("ui_select"):
        var new_dummy = dummy.instance()
        new_dummy.global_transform.origin = Vector3(rng.randf_range(-10.0, 10.0),0.02,rng.randf_range(-10.0, 10.0))
        add_child(new_dummy)
    
