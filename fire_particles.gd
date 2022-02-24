tool
extends Spatial
onready var particles = $Particles
onready var light_1 = $Particles/omni_1
onready var light_2 = $Particles/omni_2
var lights = []

func _ready():
    lights = [light_1, light_2]
    muzzle_off()

func muzzle_off():
    particles.emitting = false
    for light in lights:
        light.hide()

func muzzle_on():
    particles.emitting = true
    for light in lights:
        light.show()
