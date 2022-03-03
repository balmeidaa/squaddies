extends Spatial

var resolution
var position3D
export(PackedScene) var dummy
const squad_factory = preload("Squad.tscn") #preload("Squad.tscn")
var squad_1
var squad_2

var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    squad_1 = squad_factory.instance()
    squad_2 = squad_factory.instance()

    add_child(squad_1)
    add_child(squad_2)
    InputHandler.connect("order_move", self, "move_selected_squad")
    resolution = Vector2(get_viewport().size.x, get_viewport().size.y)
    $RadialMenu.set_up(resolution)
    $RadialMenu.rect_global_position = resolution/2
    #$Debugger.add_property(InputHandler, "squad_selected", "")



func _unhandled_input(event):
    var mouse_position = get_mouse_3Dposition()
    
    
    #Debug purposes
    if event.is_action_pressed("ui_accept"):
        var new_dummy = dummy.instance()
        new_dummy.global_transform.origin = Vector3(rng.randf_range(-10.0, 10.0),0,rng.randf_range(-10.0, 10.0))
        add_child(new_dummy)
    
    if event is InputEventMouseMotion:
        if mouse_position:
            InputHandler.player_1_look_at(mouse_position)
    if event.is_action_pressed("select_squad_1"):
        InputHandler.set_squad(1)
    if event.is_action_pressed("select_squad_2"):
        InputHandler.set_squad(2)
    if event.is_action_pressed("select_team"):
        InputHandler.set_squad(0)
    if event.is_action_pressed("squad_menu"):
        InputHandler.toggle_radial_menu(event.position)
        InputHandler.set_target_position(mouse_position)
        $Marker.transform.origin = mouse_position
#        print("mouse_position "+ str(mouse_position))
#        print("event.position "+ str(event.position))

func move_selected_squad():
    
    var squad_name = "squad_" + String(InputHandler.squad_selected)
    
    match squad_name:
        "squad_1":
            squad_1.move_squad()
        "squad_2":
            squad_2.move_squad()
        _:
            var team = get_tree().get_nodes_in_group("team")
            for squad in team:
                squad.move_squad()  
            

func get_mouse_3Dposition() -> Vector3:
    var position2D = get_viewport().get_mouse_position()
    var dropPlane  = Plane(Vector3(0, 1, 0), 0)
    var from = $Camera.project_ray_origin(position2D)
    var to = $Camera.project_ray_normal(position2D)
    position3D = dropPlane.intersects_ray(from,to)
    return position3D
