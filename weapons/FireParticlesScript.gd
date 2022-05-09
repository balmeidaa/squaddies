extends Spatial
onready var particles = $Particles
onready var light = $Particles/omni

func _ready():
    muzzle_off()

func muzzle_off():
    particles.emitting = false
    light.hide()

func muzzle_on():
    particles.emitting = true
    light.show()
