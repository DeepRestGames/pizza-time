extends Node

@onready var main_loop = $AudioStreamPlayer_MainLoop
@onready var distorted_loop = $AudioStreamPlayer_DistortedLoop
@onready var ambient_loop = $AudioStreamPlayer_AmbientLoop
var main_loop_audio_bus = AudioServer.get_bus_index("Main_Loop")
var distorted_loop_audio_bus = AudioServer.get_bus_index("Distorted_Loop")
var ambient_loop_audio_bus = AudioServer.get_bus_index("Ambient_Loop")

var max_target_volume = 0
var min_target_volume = -30
@export var loop_change_timescale = 0.5
var switching_loops = false

var current_loop: LoopType
var current_loop_bus: int
var previous_loop_bus: int

enum LoopType {
	MAIN_LOOP,
	DISTORTED_LOOP,
	AMBIENT_LOOP
}


func _ready():
	current_loop = LoopType.DISTORTED_LOOP
	current_loop_bus = distorted_loop_audio_bus
	previous_loop_bus = main_loop_audio_bus


func _process(delta):
	if switching_loops:
		var current_loop_audio_bus_volume = AudioServer.get_bus_volume_db(current_loop_bus)
		var previous_loop_audio_bus_volume = AudioServer.get_bus_volume_db(previous_loop_bus)
		var current_loop_volume: float
		var previous_loop_volume: float
		
		current_loop_volume = lerpf(current_loop_audio_bus_volume, max_target_volume, delta * loop_change_timescale)
		previous_loop_volume = lerpf(previous_loop_audio_bus_volume, min_target_volume, delta * loop_change_timescale)
		
		AudioServer.set_bus_volume_db(current_loop_bus, current_loop_volume)
		AudioServer.set_bus_volume_db(previous_loop_bus, previous_loop_volume)
		
		if AudioServer.get_bus_volume_db(previous_loop_bus) <= min_target_volume + 1:
			AudioServer.set_bus_mute(previous_loop_bus, true)
			AudioServer.set_bus_volume_db(previous_loop_bus, min_target_volume)
			AudioServer.set_bus_volume_db(current_loop_bus, max_target_volume)
			switching_loops = false

# Converts from linear energy to decibels (audio). This can be used to implement volume sliders that behave as expected (since volume isn't linear).

# Example:

# "Slider" refers to a node that inherits Range such as HSlider or VSlider.
# Its range must be configured to go from 0 to 1.
# Change the bus name if you'd like to change the volume of a specific bus only.
#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($Slider.value))



func switch_loops(new_loop):
	if new_loop == current_loop:
		return
	
	previous_loop_bus = current_loop_bus
	current_loop = new_loop
	
	match new_loop:
		LoopType.MAIN_LOOP:
			current_loop_bus = main_loop_audio_bus
		LoopType.DISTORTED_LOOP:
			current_loop_bus = distorted_loop_audio_bus
		LoopType.AMBIENT_LOOP:
			current_loop_bus = ambient_loop_audio_bus
	
	AudioServer.set_bus_mute(current_loop_bus, false)
	switching_loops = true
