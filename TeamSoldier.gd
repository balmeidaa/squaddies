extends KinematicBody

export var speed = 10
export var gravity = -5

var target = null
var velocity = Vector3.ZERO
var distance = null
var contact = false
var enemy_contact = false
var enemy_target = null
onready var fire_point = $FirePosition

# cambiar physycs_procces
#usar estados
func _ready():
    $AnimationPlayer.set_animation("idle")

func _physics_process(delta):
    var current_animation = $AnimationPlayer.current_animation
    move_to(delta)

func move_to(delta):
    velocity.y += gravity * delta
    if target:
        distance = transform.origin.distance_to(target)
        $AnimationPlayer.set_animation("move_to")
        look_at(target, Vector3.UP)
        rotation.x = 0
        velocity = -transform.basis.z * speed     
        if transform.origin.distance_to(target) < 1.5:
             stop_moving()
    velocity = move_and_slide(velocity, Vector3.UP)

func stop_moving():
    $AnimationPlayer.set_animation("idle")
    target = null
    velocity = Vector3.ZERO

func _on_Area_body_entered(_body):
    contact = true  
    if target != null and transform.origin.distance_to(target) < 5:
        stop_moving()
    
func _on_Area_body_exited(body):
    contact = false


func _on_EnemyDetector_body_entered(body):
    if body.is_in_group("enemy"):
        stop_moving()
        enemy_contact = true
        enemy_target = body.transform.origin
        look_at(enemy_target, Vector3.UP)
        $AnimationPlayer.set_animation("attack")



func _on_EnemyDetector_body_exited(body):
     enemy_contact = false
     if target == null:
        
        $AnimationPlayer.set_animation("idle")
     else:
        $AnimationPlayer.set_animation("move_to")
