extends ClippedCamera

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(5, 5)  # Maximum hor/ver shake in pixels.

export (NodePath) var target  # Assign the node this camera will follow.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var x
onready var TweenAnimator = $Tween

func _ready():
    randomize()
    noise.seed = randi()
    noise.period = 4
    noise.octaves = 2
    EventHandler.connect("explosion_shake", self, "check_distance")


func _process(delta):
    
    if trauma:
        trauma = max(trauma - decay * delta, 0)
        shake()
   
    elif (v_offset != 0 or h_offset != 0) and not TweenAnimator.is_active():
        
        TweenAnimator.interpolate_property(self, "h_offset", h_offset, 0, 0.5,
        Tween.TRANS_QUART, Tween.EASE_IN_OUT)
        
        TweenAnimator.interpolate_property(self, "v_offset", v_offset, 0, 0.5,
        Tween.TRANS_QUART, Tween.EASE_IN_OUT)
        
        TweenAnimator.start()
      
    
func shake():
    var amount = pow(trauma, trauma_power)
    noise_y += 1

    h_offset =  h_offset + max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
    v_offset = v_offset + max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

    
func add_trauma(amount):
    trauma = min(trauma + amount, 1.0)
    
func check_distance(explosion_coords):
    var explosion_distance = self.global_transform.origin.distance_to(explosion_coords)
    var trauma = pow(explosion_distance, -1)
    add_trauma(trauma/1.2)

