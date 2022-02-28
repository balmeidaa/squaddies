extends KinematicBody

export var speed = 10
export var gravity = -5

var target = null
var hit_points = 100
var velocity = Vector3.ZERO
var distance = null
var contact = false
onready var fire_point = $FirePosition
#state machine goes here
