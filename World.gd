extends Spatial

var resolution

export(PackedScene) var dummy
const squad_factory = preload("Squad.tscn")
const camera_factory = preload("misc/Camera.tscn")
const player_factory = preload("PlayerSoldier.tscn")

var squad_1
var squad_2
var players = []

onready var screen = $Control/Screen

var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
#    squad_1 = squad_factory.instance()
#    squad_2 = squad_factory.instance()
#    squad_1.set_up_squad(1)
#    squad_2.set_up_squad(1)
#    add_child(squad_1)
#    add_child(squad_2)
   
    Input.connect("joy_connection_changed", self, "_joy_connection_changed")

    if Input.get_connected_joypads().size() > 0:
        #Agregar jugadores via loop
        #$Player.device_id = Input.get_connected_joypads()[0]
        pass
    else:

        add_new_player(1)
        #add_new_player(2)

#    $Debugger.add_property($Player/Camera, "dis", "")
#    $Debugger.add_property($Player/Cursor, "position", "")
#    $Debugger.add_property($Player, "motion", "")

func add_new_player(player_index):
    var new_player = player_factory.instance()
    var cam = camera_factory.instance()
    var cam_name = "camera_p{n}".format({"n":player_index})
    cam.set_name(cam_name)
    new_player.camera = cam
    players.append(new_player)
    new_player.transform.origin = Vector3(-3*player_index,0.02,player_index)
    screen.get_node("Viewport{n}/Viewport".format({"n":player_index})).add_child(cam)
    screen.get_node("Viewport{n}/Viewport".format({"n":player_index})).add_child(new_player)

func _joy_connection_changed(device_id:int, connected:bool):
    print('000')
#    if connected:
#        print('in')
#        $Player.device_id = device_id
#    else:
#        $Player.device_id = -1
    



func _unhandled_input(event):
    #Debug purposes
    if event.is_action_pressed("ui_accept"):
        var new_dummy = dummy.instance()
        new_dummy.global_transform.origin = Vector3(rng.randf_range(-10.0, 10.0),0.02,rng.randf_range(-10.0, 10.0))
        add_child(new_dummy)
    
