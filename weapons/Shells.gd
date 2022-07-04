extends Spatial

func _ready():
    stop()
    
    
func set_shells_drop(shells:int):
    self.amount = shells

func stop():
    self.emitting = false


func start():
    self.emitting = true

