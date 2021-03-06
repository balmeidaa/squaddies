extends Spatial
class_name Gun


onready var rof_timer = $RofTimer as Timer
onready var reload_timer = $ReloadTimer
onready var fire_point = $FirePoint
onready var muzzle = $Muzzle
onready var shells = $Shells
var can_shoot = true

export var gun_name = "Pistol"
export(PackedScene) var Bullet
export var max_ammo = 30
export var bullet_speed = 30
export var bullet_damage = 15
export var fly_time = 4
export var millis_between_shots = 100

var current_ammo = max_ammo
export var shells_drop = 5

var reloading = false
var trigger_released = true
enum FireMode {
    SINGLE,
    BURST,
    AUTO
   }

export (FireMode) var fire_mode = FireMode.AUTO

export (int) var burts_shots = 3
var remaining_burst_shots = burts_shots


func _ready():
    rof_timer.wait_time = millis_between_shots / 1000.0
    rof_timer.start()
    shells.set_shells_drop(shells_drop)

    
func fire():
    
    if current_ammo <= 0 and not reloading:
        reload_weapon()
        shells.stop()
        return false
        
    elif can_shoot and current_ammo > 0:
        
        var new_bullet = Bullet.instance()
        new_bullet.global_transform = fire_point.global_transform
        new_bullet.init_bullet(bullet_damage, bullet_speed, fly_time)
        new_bullet.set_as_toplevel(true)
        var scene_root = get_tree().get_root().get_children()[0]
        scene_root.add_child(new_bullet)
        can_shoot = false
        muzzle.muzzle_on()
        shells.start()
        rof_timer.start()
        current_ammo -= 3
        return true



func hold_trigger():
    match fire_mode:
        FireMode.SINGLE:
            if trigger_released:
                fire()
        FireMode.BURST:
            if remaining_burst_shots:
                if fire():
                    remaining_burst_shots -= 1
        FireMode.AUTO:
             fire()
    
    trigger_released = false

func release_trigger():
    trigger_released = true
    shells.stop()
    resets_burst_shots()

func reload_weapon():
    reloading = true
    reload_timer.start()
 

func resets_burst_shots():
    remaining_burst_shots = burts_shots

func _on_ReloadTimer_timeout():
    current_ammo = 30
    reloading = false


func _on_Timer_timeout():
    muzzle.muzzle_off()
    can_shoot = true
