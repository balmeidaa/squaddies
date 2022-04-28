extends Spatial

export(PackedScene) var Bullet

onready var rof_timer = $RofTimer as Timer
onready var reload_timer = $ReloadTimer
var can_shoot = true

export var max_ammo = 30
export var bullet_speed = 30
export var bullet_damage = 15
export var fly_time = 4
export var millis_between_shots = 100
onready var parent = get_parent()
var current_ammo = max_ammo

var reloading = false
#refactor to weapon scene
func _ready():
    rof_timer.wait_time = millis_between_shots / 1000.0
    rof_timer.start()

    
func fire():
    if current_ammo <= 0 and not reloading:
        reload_weapon()
    elif can_shoot and current_ammo > 0:
        var new_bullet = Bullet.instance()
        new_bullet.global_transform = global_transform
        new_bullet.init_bullet(bullet_damage, bullet_speed, fly_time)
        #new_bullet.set_as_toplevel(true)
        var scene_root = get_tree().get_root().get_children()[0]
        scene_root.add_child(new_bullet)
        can_shoot = false
        $Muzzle.muzzle_on()
        rof_timer.start()
        current_ammo -= 3


func reload_weapon():
    reloading = true
    parent.set_reload(reloading)
    reload_timer.start()
 
func _on_ReloadTimer_timeout():
    current_ammo = 30
    reloading = false
    parent.set_reload(reloading)


func _on_Timer_timeout():
    $Muzzle.muzzle_off()
    can_shoot = true
