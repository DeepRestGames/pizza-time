extends Control

var main_scene_path = "res://Scenes/Prototypes/ChryslerBuilding_Prototype05.tscn"
@onready var pizza_texture = $AspectRatioContainer

var min_loading_time = 5
var current_loading_time = 0

func _ready():
	ResourceLoader.load_threaded_request(main_scene_path)
	
	var pizza_texture_size = pizza_texture.size
	pizza_texture.pivot_offset = pizza_texture_size / 2

func _process(delta):
	var loading_progress = ResourceLoader.load_threaded_get_status(main_scene_path)
	
	current_loading_time += delta
	
	if loading_progress == ResourceLoader.THREAD_LOAD_LOADED and current_loading_time >= min_loading_time:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(main_scene_path))
