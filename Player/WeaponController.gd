extends Position3D

var equipped_weapon: Gun = null
onready var parent = get_parent().get_parent()
onready var reload_timer = $ReloadTimer
var grenades = MAX_GRENADES
const AIM_TIME = 0.3
const HIP_DISTANCE = 0.646
const MAX_GRENADES = 3
const THROW_FORCE = 50
var default = preload("res://weapons/GunTemplate.tscn")
var pistol = preload("res://weapons/Pistol.tscn")
var auto_rifle = preload("res://weapons/AutoRifle.tscn")
var semi_auto = preload("res://weapons/SemiAuto.tscn")
onready var animation = get_node("../AimDown")

var max_cap_ammo = 0
var current_ammo = 0
var ammo_available = 0
var weapon_name = 0  

const grenade_factory = preload("res://weapons/Grenade.tscn")


var aiming_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
    if equipped_weapon == null:
        equip_weapon("default")
        
    
func equip_weapon(weapon_to_equip:String):
    
    
    if equipped_weapon and weapon_to_equip != equipped_weapon.get_weapon_name():
        drop_weapon() 
    
    equipped_weapon = weapon_factory(weapon_to_equip).instance()
    equipped_weapon.equiped = true
    
    max_cap_ammo = equipped_weapon.get_max_ammo_cap()
    current_ammo = equipped_weapon.get_current_ammo()
    ammo_available = equipped_weapon.get_ammo_available()
    weapon_name = equipped_weapon.get_weapon_name()  
     
    add_child(equipped_weapon)
    
    if "player_index" in parent:
        reload_timer.wait_time = equipped_weapon.get_reload_time()
        HudHandler.ammo_signal(parent.player_index, current_ammo, ammo_available)


func hold_trigger():
    if equipped_weapon:
        equipped_weapon.hold_trigger()
        if "player_index" in parent:
            current_ammo = equipped_weapon.get_current_ammo()
            HudHandler.ammo_signal(parent.player_index, current_ammo, ammo_available)
    
func release_trigger():
    if equipped_weapon:
        equipped_weapon.release_trigger()
    
               
func weapon_factory(type):
    match type:
        "pistol":
            return pistol
        "auto_rifle":
            return auto_rifle
        "uzi":
            return semi_auto
        "default":
            return default

func aim_down():
    if aiming_down:
        return
   
    animation.interpolate_property(self, "translation:x", self.transform.origin.x, 0, AIM_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
    animation.start()
    
    aiming_down = true
    
func aim_from_hip():
    
    if not aiming_down:
        return
        
    animation.interpolate_property(self, "translation:x", self.transform.origin.x, HIP_DISTANCE, AIM_TIME, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
    animation.start()
    aiming_down = false
    
func drop_weapon():
    equipped_weapon.drop()
    equipped_weapon.set_as_toplevel(true)
    equipped_weapon.global_transform = self.global_transform
    equipped_weapon.apply_torque_impulse(-equipped_weapon.global_transform.basis.z*2) 
    equipped_weapon.apply_impulse(Vector3(0,0,0), -equipped_weapon.global_transform.basis.z * THROW_FORCE/2)

func reload_weapon():
    equipped_weapon.reload_weapon()
    if "player_index" in parent:
        reload_timer.start()
         
    
func add_grenades(grenade):
    if grenades == MAX_GRENADES:
        return false
        
    grenades += grenade
    
    if "player_index" in parent:
        HudHandler.grenade_signal(parent.player_index, grenades)
        
    return true
        
func add_ammo(ammo_mags):
    if equipped_weapon.full_ammo():
        return false
        
    equipped_weapon.set_ammo_available(ammo_mags)
    
    if parent.player_index:
        current_ammo = equipped_weapon.get_current_ammo()
        ammo_available = equipped_weapon.get_ammo_available()
        HudHandler.ammo_signal(parent.player_index, current_ammo, ammo_available)
    return true
  
func get_grenades():
        return grenades
    
func throw_grenade():
    if grenades > 0:
        var grenade = grenade_factory.instance()
        get_tree().root.add_child(grenade)
        grenade.global_transform = self.global_transform
        grenade.apply_torque_impulse(-grenade.global_transform.basis.z*2) 
        grenade.apply_impulse(Vector3(0,0,0), -grenade.global_transform.basis.z * THROW_FORCE)
        grenades -= 1
        if "player_index" in parent:
            HudHandler.grenade_signal(parent.player_index, grenades)

func check_gun_type():
    if equipped_weapon.fire_mode == equipped_weapon.FireMode.SINGLE or equipped_weapon.fire_mode == equipped_weapon.FireMode.BURST: 
        return true
    return false
    
func _on_ReloadTimer_timeout():
    if "player_index" in parent:
        reload_timer.start()
        current_ammo = equipped_weapon.get_current_ammo()
        ammo_available = equipped_weapon.get_ammo_available()
        HudHandler.ammo_signal(parent.player_index, current_ammo, ammo_available)
