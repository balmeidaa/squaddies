extends Spatial

onready var anim_player = $AnimationPlayer as AnimationPlayer


func _explode():
    anim_player.play("explosion")


func set_up():
    $Explosion.emitting = false
    $Smoke.emitting = false
    anim_player.stop()
    
