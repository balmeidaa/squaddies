extends RigidBody
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

export(String, FILE, "*.wav") var audio_click

export(String, FILE, "*.wav") var audio_reload

onready var audio_player = $SpatialAudio
onready var single_player = $SingleAudio

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

func _physics_process(delta):
    if not trigger_released:
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
 
func drop():
    equiped = false
    gravity_active = true 
    $Area.monitoring = false
    $DropTimer.start()
   

func fire():
    
    var sound_index = randi() % sound_files.size()
    
    if current_ammo <= 0 and not reloading:
        single_player.stream = load(audio_click)
        single_player.play()
         
        shells.stop()
        return false
        
    elif can_shoot and current_ammo > 0:
        audio_player.play(sound_files[sound_index])
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
        return true



func hold_trigger():
    trigger_released = false

func release_trigger():
    trigger_released = true
    if fire_mode == FireMode.BURST:
        remaining_burst_shots = burts_shots
    shells.stop()


func reload_weapon():
    if reloading:
        return
        
    single_player.stream = load(audio_reload)
    single_player.play()
    if ammo_available == 0:
        reloading = false
        return
    reloading = true
    reload_timer.start()
 

func _on_ReloadTimer_timeout():

    if (ammo_available - max_mag_cap) < 0:
        current_ammo = ammo_available
        ammo_available = 0
    else:
        ammo_available = ammo_available - max_mag_cap
        current_ammo = max_mag_cap
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
    
func get_reload_time():
    return reload_timer.wait_time

func _on_Area_body_entered(body):
    if body.has_method("pick_up_weapon") and not equiped:
        body.pick_up_weapon(weapon_name)
        queue_free()


func _on_DropTimer_timeout():
    $Area.monitoring = true
