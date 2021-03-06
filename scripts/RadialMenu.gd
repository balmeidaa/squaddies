extends Control

export var radius = 70
export var speed = 0.25

var number_items
var active = false

const min_x = 75.0
const min_y = 62.0

const max_x = 140.0
const max_y = 110.0
var screen_size = Vector2.ZERO

var player_index : int
var player_device: int
onready var parent = get_parent()

onready var radio_in = preload("res://assets/sfx/radio_in.wav")
onready var radio_out = preload("res://assets/sfx/radio_out.wav")

var button_x #change weap/ order Attack
var button_y #reload / order go

var button_a #change item/regroup
var button_b #use item/defend
 
func _ready():
    player_index = parent.player_index
    player_device = parent.device_id
    
    button_x = "x_p{n}".format({"n":player_index})
    button_y = "y_p{n}".format({"n":player_index})
    button_a = "a_p{n}".format({"n":player_index})
    button_b = "b_p{n}".format({"n":player_index})
    
    var resolution = Vector2(get_viewport().size.x, get_viewport().size.y)
    set_up(resolution)
    rect_global_position = resolution/2
    InputHandler.connect("invoke_radial_menu", self, "toggle_menu")
    number_items = $Control.get_child_count()
    for buttons in $Control.get_children():
        buttons.rect_global_position = rect_global_position
        buttons.hide()
        
        
func _unhandled_input(event):
    
    if active and player_device > -1:

         if Input.is_action_pressed(button_x):
            _on_Attack_pressed()
         if Input.is_action_pressed(button_y):
            _on_Go_pressed()
         if Input.is_action_pressed(button_a):
            _on_Regroup_pressed()
         if Input.is_action_pressed(button_b):
            _on_Defend_pressed()


func set_up(resolution:Vector2):
    screen_size = resolution

func toggle_menu(player:int, position:Vector2):
    if player == player_index:
        active = !active
        if active:
            show_menu(position)
        else:
            hide_menu()


func show_menu(position):
    $AudioStream.stream = radio_in
    
    var spacing = TAU / number_items
    position.x = clamp(position.x, min_x, (screen_size.x - max_x)) 
    position.y = clamp(position.y, min_y, (screen_size.y - max_y)) 
    
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
    $AudioStream.play()
    
func hide_menu():
    active = false
    $AudioStream.stream = radio_out
    for buttons in $Control.get_children():
        $Tween.interpolate_property(buttons, "rect_position", buttons.rect_position,
                 Vector2.ZERO, speed, Tween.TRANS_BACK, Tween.EASE_IN)
        $Tween.interpolate_property(buttons, "rect_scale", null,
                Vector2(0.5, 0.5), speed, Tween.TRANS_LINEAR)
    $Tween.start()
    $AudioStream.play()

func _on_Tween_tween_all_completed():
    if not active:
         for buttons in $Control.get_children():
            buttons.hide()


func _on_Regroup_pressed():
    InputHandler.order_squad(player_index,"regroup")
    hide_menu()


func _on_Go_pressed():
    InputHandler.order_squad(player_index,"move_squad")
    hide_menu()


func _on_Attack_pressed():
    InputHandler.order_squad(player_index,"attack") 
    hide_menu()


func _on_Defend_pressed():
    InputHandler.order_squad(player_index,"defend")
    hide_menu()
