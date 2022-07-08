extends Spatial
onready var particles = $Particles
onready var light = $Particles/omni
onready var emit_timer = $EmitTimer

func _ready():
    muzzle_off()

func muzzle_off():
    particles.emitting = false
    light.hide()

func muzzle_on():
    emit_timer.start()
    particles.emitting = true
    light.show()


func _on_EmitTimer_timeout():
    muzzle_off()
