extends Position3D

export (PackedScene) var default_gun
var equipped_weapon: Gun
var weapon_inventory: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
    print(default_gun)
    if default_gun:
        equip_weapon(default_gun)
        
    
func equip_weapon(weapon_to_equip):
    if equipped_weapon:
        equipped_weapon.queue_free()
    
    equipped_weapon = weapon_to_equip.instance()
    add_child(equipped_weapon)

func hold_trigger():
    if equipped_weapon:
        equipped_weapon.hold_trigger()
    
func release_trigger():
    if equipped_weapon:
        equipped_weapon.release_trigger()
