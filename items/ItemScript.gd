extends StaticBody

enum ItemType {
    HEALTH,
    AMMO,
    GRENADE,
    HAZARD
   }

export (ItemType) var item_type = ItemType.HEALTH


func _ready():
    pass 

func _on_pick_up(body):
    pass

func _use_item():
    pass

func _on_destroy():
    pass
