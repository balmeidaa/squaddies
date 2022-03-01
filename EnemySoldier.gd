extends KinematicBody

export var speed = 10
export var gravity = -5

var target = null
var hit_points = 100
var velocity = Vector3.ZERO
var distance = null
var contact = false
onready var fire_point = $FirePosition
    
func bullet_hit(bullet_damage):
    hit_points -= bullet_damage
    $Debug/Viewport/Label.text = str(hit_points)
    if hit_points < 0:
        call_deferred("queue_free")
