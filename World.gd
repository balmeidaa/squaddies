extends Spatial

var resolution
var position3D

const squad_factory = preload("res://squad.tscn")
var squad_1
var squad_2

func _ready():
    squad_1 = squad_factory.instance()
    squad_2 = squad_factory.instance()

    add_child(squad_1)
    add_child(squad_2)
    UiInputHandler.connect("order_move", self, "move_selected_squad")

    resolution = Vector2(get_viewport().size.x, get_viewport().size.y)
    $RadialMenu.rect_position = resolution/2

    $Debugger.add_property(UiInputHandler, "squad_selected", "")



func _unhandled_input(event):
    var mouse_position = get_mouse_position()
    
    if event.is_action_pressed("ui_select_squad_1"):
        UiInputHandler.set_squad(1)
    if event.is_action_pressed("ui_select_squad_2"):
        UiInputHandler.set_squad(2)
    if event.is_action_pressed("ui_select_all"):
        UiInputHandler.set_squad(0)
    if event.is_action_pressed("ui_squad_menu"):
        UiInputHandler.toggle_radial_menu(event.position)
        UiInputHandler.set_target_position(mouse_position)
        $Marker.transform.origin = mouse_position
#    if event.is_action_released("ui_squad_menu"):
#        UiInputHandler.toggle_radial_menu(event.position)

func move_selected_squad():
    
    var squad_name = "squad_" + String(UiInputHandler.squad_selected)
    
    match squad_name:
        "squad_1":
            squad_1.move_squad()
        "squad_2":
            squad_2.move_squad()
        _:
            var team = get_tree().get_nodes_in_group("team")
            for squad in team:
                squad.move_squad()  
            

func get_mouse_position() -> Vector3:
    var position2D = get_viewport().get_mouse_position()
    var dropPlane  = Plane(Vector3(0, 1, 0), 0)
    var from = $Camera.project_ray_origin(position2D)
    var to = $Camera.project_ray_normal(position2D)
    position3D = dropPlane.intersects_ray(from,to)
    return position3D
