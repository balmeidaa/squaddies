extends RigidBody

export var AREA_DAMAGE := 100
onready var timer_explosion = $Timer 
onready var explosion_vfx = $Explosion
onready var explosion_area = $ExplosionArea
onready var grenade_model = $grenade
export var distance_damage_multiplier = 6

func _ready():
    timer_explosion.start()
    explosion_vfx.set_up()

 
func explode():
    grenade_model.hide()
    explosion_vfx._explode()
    for body in explosion_area.get_overlapping_bodies():  
        if body.has_method("_recieve_damage"):
            var explosion_damage = AREA_DAMAGE - transform.origin.distance_to(body.transform.origin) * distance_damage_multiplier
            body._recieve_damage(explosion_damage)
        elif body.has_method("_on_destroy") and body.has_method("is_destroyed"):
            if not body.is_destroyed():
                body._on_destroy()
    
    
func _on_Timer_timeout():
    explode()


func _on_VfxTimer_timeout():
    queue_free()

