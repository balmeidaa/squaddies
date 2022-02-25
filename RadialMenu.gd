extends Control

export var radius = 70
export var speed = 0.25

var number_items
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
    UiRadialMenuHandler.connect("invoke_radial_menu", self, "toggle_menu")
    number_items = $Control.get_child_count()
    for buttons in $Control.get_children():
        buttons.rect_global_position = rect_global_position
        buttons.hide()


func toggle_menu(position:Vector2):
    active = !active
    if active:
        show_menu(position)
    else:
        hide_menu()


func show_menu(position):
    var spacing = TAU / number_items
    for buttons in $Control.get_children():
        buttons.show()
        # Subtract PI/2 to align the first button  to the top
        var angle = spacing * buttons.get_position_in_parent() - PI / 2
        var dest = position + Vector2(radius, 0).rotated(angle)
        $Tween.interpolate_property(buttons, "rect_position",
                buttons.rect_position, dest, speed,
                Tween.TRANS_BACK, Tween.EASE_OUT)
        $Tween.interpolate_property(buttons, "rect_scale",
                Vector2(0.5, 0.5), Vector2.ONE, speed,
                Tween.TRANS_LINEAR)
    $Tween.start()
    
func hide_menu():
    for buttons in $Control.get_children():
        $Tween.interpolate_property(buttons, "rect_position", buttons.rect_position,
                 Vector2.ZERO, speed, Tween.TRANS_BACK, Tween.EASE_IN)
        $Tween.interpolate_property(buttons, "rect_scale", null,
                Vector2(0.5, 0.5), speed, Tween.TRANS_LINEAR)
    $Tween.start()


func _on_Tween_tween_all_completed():
    if not active:
         for buttons in $Control.get_children():
            buttons.hide()


func _on_Regroup_pressed():
    pass # Replace with function body.


func _on_Go_pressed():
    UiRadialMenuHandler.order_squad()
    active = false
    hide_menu()


func _on_Attack_pressed():
    pass # Replace with function body.
