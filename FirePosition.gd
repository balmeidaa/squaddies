extends Position3D

export(PackedScene) var Bullet

onready var rof_timer = $Timer
var can_shoot = true

export var muzzle_speed = 30
export var millis_between_shots = 100
#refactor to weapon scene
func _ready():
    rof_timer.wait_time = millis_between_shots / 1000.0
    rof_timer.start()

    
func fire():
    if can_shoot:
        var new_bullet = Bullet.instance()
        new_bullet.global_transform = global_transform
  #      new_bullet.speed = muzzle_speed
        var scene_root = get_tree().get_root().get_children()[0]
        scene_root.add_child(new_bullet)
        can_shoot = false
        $Muzzle.muzzle_on()
        rof_timer.start()


func _on_Timer_timeout():
    $Muzzle.muzzle_off()
    can_shoot = true
