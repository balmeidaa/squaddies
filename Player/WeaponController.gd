extends Position3D

var equipped_weapon: Gun = null
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

var default = preload("res://weapons/GunTemplate.tscn")
var pistol = preload("res://weapons/Pistol.tscn")
var auto_rifle = preload("res://weapons/AutoRifle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    if weapon_inventory.size() == 0:
        equip_weapon("default")
        
    
func equip_weapon(weapon_to_equip:String):
    
    if equipped_weapon and weapon_to_equip != equipped_weapon.get_weapon_name():
        equipped_weapon.queue_free()
    
    equipped_weapon = weapon_factory(weapon_to_equip).instance()
    equipped_weapon.equiped = true
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
    if inventory_empty():
         weapon_inventory.append(weapon_info)
    elif weapon_inventory.size() == 1:
         weapon_inventory.push_front(weapon_info)
    else:
        var weapon = weapon_inventory.pop_front()
        print(weapon["weapon_object"])
        weapon["weapon_object"].drop()
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
            
func switch_weapon():
    if not inventory_empty() and weapon_inventory.size() == 2:
        var current_weapon = weapon_inventory.pop_front()
        weapon_inventory.append(current_weapon)
        print("swi")
        equip_weapon(weapon_inventory[0]["weapon_name"])
        

func inventory_empty():
    return  weapon_inventory.size() == 0                  
func weapon_factory(type):
    match type:
        "pistol":
            return pistol
        "auto_rifle":
            return auto_rifle
        "default":
            return default
