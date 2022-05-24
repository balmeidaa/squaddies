extends Position3D

export (PackedScene) var default_gun
var equipped_weapon: Gun
var weapon_inventory: Array = []
enum BulletType {
    LIGHT,
    HEAVY,
    SHELL
   }
var light_ammo = 0
var heavy_ammo = 0
var shells = 0
var grenades = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    if default_gun:
        equip_weapon(default_gun)
        
    
func equip_weapon(weapon_to_equip):
    if equipped_weapon:
        equipped_weapon.queue_free()
    
    equipped_weapon = weapon_to_equip.instance()
    var max_cap_ammo = equipped_weapon.get_max_ammo_cap()
    var ammo_in_gun = equipped_weapon.get_current_ammo()
    var weapon_name = equipped_weapon.get_weapon_name()
    var current_ammo = get_ammo_type(equipped_weapon.bullet_type)   

    
    var weapon_info = {
        "weapon_object":equipped_weapon,
        "weapon_name":weapon_name,
        "total_current_ammo": (current_ammo + ammo_in_gun),
        "max_cap_ammo":max_cap_ammo
       }
    if weapon_inventory.size() == 0:
         weapon_inventory.append(weapon_info)
    elif weapon_inventory.size() == 1:
         weapon_inventory.push_front(weapon_info)
    else:
        weapon_inventory.pop_front()
        weapon_inventory.append(weapon_info)
        
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

func get_ammo_type(bullet_type):
    match bullet_type:
        BulletType.LIGHT:
            return light_ammo
        BulletType.HEAVY:
            return heavy_ammo
        BulletType.SHELL:
            return shells        
