extends Node2D

var viewport_rect

func _ready():
    viewport_rect = get_viewport().size

func set_cursor_position(new_position: Vector2):
    position.x = clamp(new_position.x, 0.0, viewport_rect.x)
    position.y = clamp(new_position.y, 0.0, viewport_rect.y)
 
