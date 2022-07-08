extends Position3D

var equipped_weapon: Gun = null

var grenades = 0
const AIM_TIME = 0.3
const HIP_DISTANCE = 0.646
const MAX_GRENADES = 3
const THROW_FORCE = 50
var default = preload("res://weapons/GunTemplate.tscn")
var pistol = preload("res://weapons/Pistol.tscn")
var auto_rifle = preload("res://weapons/AutoRifle.tscn")
var semi_auto = preload("res://weapons/SemiAuto.tscn")
onready var animation = get_node("../Tween")

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
    var max_cap_ammo = equipped_weapon.get_max_ammo_cap()
    var current_ammo = equipped_weapon.get_current_ammo()
    var ammo_available = equipped_weapon.get_ammo_available()
    var weapon_name = equipped_weapon.get_weapon_name()  

    
    var weapon_info = {
        "weapon_object":equipped_weapon,
        "weapon_name":weapon_name,
        "ammo_in_mag":current_ammo,
        "max_cap_mag":max_cap_ammo,
        "total_ammo": (current_ammo + ammo_available),
        "max_cap_ammo":max_cap_ammo
       }
    
 
     
        
    add_child(equipped_weapon)


func hold_trigger():
    if equipped_weapon:
        equipped_weapon.hold_trigger()
    
func release_trigger():
    if equipped_weapon:
        equipped_weapon.release_trigger()

func check_gun_type():
    if equipped_weapon.fire_mode == equipped_weapon.FireMode.SINGLE or equipped_weapon.fire_mode == equipped_weapon.FireMode.BURST: 
        return true
    return false
  
    
               
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

func weapon_realod():
    equipped_weapon.reload_weapon()
    
func throw_grenade(angle_radians:float):
    var grenade = grenade_factory.instance()
    get_tree().root.add_child(grenade)
    grenade.global_transform = self.global_transform
    grenade.apply_torque_impulse(-grenade.global_transform.basis.z*2) 
    grenade.apply_impulse(Vector3(0,0,0), -grenade.global_transform.basis.z * THROW_FORCE)
