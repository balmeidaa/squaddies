extends Spatial
onready var particles = $Particles as Particles


func _ready():
    stop()
    
    
func set_shells_drop(shells:int):
    particles.amount = shells

func stop():
    particles.emitting = false


func start():
    particles.emitting = true

