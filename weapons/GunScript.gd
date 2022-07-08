extends Spatial
class_name Gun

onready var rof_timer = $RofTimer as Timer
onready var reload_timer = $ReloadTimer
onready var fire_point = $FirePoint
onready var muzzle = $Muzzle
onready var shells = $Shells
var can_shoot = true
export var weapon_name = "default"
export(PackedScene) var Bullet
export var max_mag_cap = 30
export var bullet_speed = 30
export var bullet_damage = 15
export var fly_time = 4
export var millis_between_shots = 100
export var max_ammo_cap = 180  
var equiped = false
var current_ammo = max_mag_cap
var ammo_available = max_ammo_cap
export var shells_drop = 5
### Audio files
export(String, FILE, "*.wav") var audio_shot_0
export(String, FILE, "*.wav") var audio_shot_1
export(String, FILE, "*.wav") var audio_shot_2

export(String, FILE, "*.wav") var audio_reload

onready var audio_player = $Audio

var sound_files = []
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
var gravity_active = false

func _ready():
    randomize()
    rof_timer.wait_time = millis_between_shots / 1000.0
    rof_timer.start()
    shells.set_shells_drop(shells_drop)
    sound_files = [audio_shot_0, audio_shot_1, audio_shot_2]

func _process(delta):
    if gravity_active and global_transform.origin.y > 0.2:
        global_transform.origin.y -= delta * 9.8
        global_translate(global_transform.basis.z.normalized() * delta * 25)
    else:
        global_transform.origin.y == 0.3
        gravity_active = false
    
func drop():
    equiped = false
    gravity_active = true 
    $Area.monitoring = false
    $DropTimer.start()
   

func fire():
    
    var sound_index = randi() % sound_files.size()
    audio_player.stream = load(sound_files[sound_index])
    audio_player.play()
    if current_ammo <= 0 and not reloading:
        reload_weapon()
        shells.stop()
        return false
        
    elif can_shoot and current_ammo > 0:
       
        audio_player.play()
        muzzle.muzzle_on()
        
        var new_bullet = Bullet.instance()
        new_bullet.global_transform = fire_point.global_transform
        new_bullet.init_bullet(bullet_damage, bullet_speed, fly_time)
        new_bullet.set_as_toplevel(true)
        var scene_root = get_tree().get_root().get_children()[0]
        scene_root.add_child(new_bullet)
        can_shoot = false
        shells.start()
        rof_timer.start()
        current_ammo -= 1
        print("current_ammo: ", current_ammo)
        return true



func hold_trigger():
    match fire_mode:
        FireMode.SINGLE:
            if trigger_released:
                fire()
        FireMode.BURST:
            for shots in remaining_burst_shots:
                fire()
                fire()
                fire() 
            remaining_burst_shots = 0
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
    if ammo_available == 0:
        reloading = false
        return
    if (ammo_available - max_mag_cap) < 0:
        current_ammo = ammo_available
        ammo_available = 0
    reloading = false


func _on_Timer_timeout():
    can_shoot = true
    
func get_weapon_name():
    return weapon_name

func get_ammo_available():
    return ammo_available

func get_max_mag_cap():
    return max_mag_cap

func get_current_ammo():
    return current_ammo

func get_max_ammo_cap():
    return max_ammo_cap

func _on_Area_body_entered(body):
    if body.has_method("pick_up_weapon") and not equiped:
        body.pick_up_weapon(weapon_name)
        queue_free()


func _on_DropTimer_timeout():
    $Area.monitoring = true
