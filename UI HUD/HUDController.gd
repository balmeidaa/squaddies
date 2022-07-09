extends Control


var format_ammo = "%d/%d"
var path_hud_p1 = "Screen/Viewport1/Viewport/HUD"
var path_hud_p2 = "Screen/Viewport2/Viewport/HUD"

var path_health_counter = "/Top/HealthContainer/HealthCounter"
var path_ammo_counter = "/Bottom/VBoxContainer/AmmoContainer/AmmoCounter"
var grenade_ammo_counter = "/Bottom/VBoxContainer/GrenadeContainer/GrenadeCounter"

var path_players_hud = [path_hud_p1, path_hud_p2]

func _ready():
    HudHandler.connect("health", self, "update_health")
    HudHandler.connect("ammo", self, "update_ammo")
    HudHandler.connect("grenade", self, "update_grenade_stock")

func update_health(player_index, value):
    var full_path = path_players_hud[player_index-1] + path_health_counter
    var label =  get_node(full_path)
    label.text = str(value)


func update_grenade_stock(player_index, value):
    var full_path = path_players_hud[player_index-1] + grenade_ammo_counter
    var label =  get_node(full_path)
    label.text = str(value)

func update_ammo(player_index, in_mag, available):
    var full_path = path_players_hud[player_index-1] + path_ammo_counter
    var label =  get_node(full_path)
    label.text = str(format_ammo% [in_mag, available])
