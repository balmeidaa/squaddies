extends Spatial

onready var anim_player = $AnimationPlayer as AnimationPlayer


func _explode():
    anim_player.play("explosion")


