extends Position3D

export(PackedScene) var Bullet

onready var rof_timer = $Timer as Timer
onready var reload_timer = $ReloadTimer
var can_shoot = true

export var muzzle_speed = 30
export var millis_between_shots = 100
onready var parent = get_parent()
export var  ammo = 30

var reloading = false
#refactor to weapon scene
func _ready():
    rof_timer.wait_time = millis_between_shots / 1000.0
    rof_timer.start()

    
func fire():
    if ammo <= 0 and not reloading:
        reloading = true
        parent.set_reload(reloading)
        reload_timer.start()
    elif can_shoot and ammo > 0:
        var new_bullet = Bullet.instance()
        new_bullet.global_transform = global_transform
  #      new_bullet.speed = muzzle_speed
        var scene_root = get_tree().get_root().get_children()[0]
        scene_root.add_child(new_bullet)
        can_shoot = false
        $Muzzle.muzzle_on()
        rof_timer.start()
        ammo -= 3

 
func _on_ReloadTimer_timeout():
    ammo = 30
    reloading = false
    parent.set_reload(reloading)


func _on_Timer_timeout():
    $Muzzle.muzzle_off()
    can_shoot = true
