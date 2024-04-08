extends Node

@onready var main_loop = $AudioStreamPlayer_MainLoop
@onready var distorted_loop = $AudioStreamPlayer_DistortedLoop
var main_loop_audio_bus = AudioServer.get_bus_index("Main_Loop")
var distorted_loop_audio_bus = AudioServer.get_bus_index("Distorted_Loop")

var max_target_volume = 0
var min_target_volume = -30
@export var loop_change_timescale = 0.5
var switching_loops = false
var activating_main = true


func _process(delta):
	if switching_loops:
		var main_loop_audio_bus_volume = AudioServer.get_bus_volume_db(main_loop_audio_bus)
		var distorted_loop_audio_bus_volume = AudioServer.get_bus_volume_db(distorted_loop_audio_bus)
		var main_loop_volume: float
		var distorted_loop_volume: float
		
		if activating_main:
			main_loop_volume = lerpf(main_loop_audio_bus_volume, max_target_volume, delta * loop_change_timescale)
			distorted_loop_volume = lerpf(distorted_loop_audio_bus_volume, min_target_volume, delta * loop_change_timescale)
		else:
			main_loop_volume = lerpf(main_loop_audio_bus_volume, min_target_volume, delta * loop_change_timescale)
			distorted_loop_volume = lerpf(distorted_loop_audio_bus_volume, max_target_volume, delta * loop_change_timescale)
		
		AudioServer.set_bus_volume_db(main_loop_audio_bus, main_loop_volume)
		AudioServer.set_bus_volume_db(distorted_loop_audio_bus, distorted_loop_volume)
		
		if !activating_main and AudioServer.get_bus_volume_db(main_loop_audio_bus) <= min_target_volume + 1:
			AudioServer.set_bus_mute(main_loop_audio_bus, true)
			AudioServer.set_bus_volume_db(main_loop_audio_bus, min_target_volume)
			AudioServer.set_bus_volume_db(distorted_loop_audio_bus, max_target_volume)
			switching_loops = false
		elif activating_main and AudioServer.get_bus_volume_db(distorted_loop_audio_bus) <= min_target_volume + 1:
			AudioServer.set_bus_mute(distorted_loop_audio_bus, true)
			AudioServer.set_bus_volume_db(main_loop_audio_bus, max_target_volume)
			AudioServer.set_bus_volume_db(distorted_loop_audio_bus, min_target_volume)
			switching_loops = false

# Converts from linear energy to decibels (audio). This can be used to implement volume sliders that behave as expected (since volume isn't linear).

# Example:

# "Slider" refers to a node that inherits Range such as HSlider or VSlider.
# Its range must be configured to go from 0 to 1.
# Change the bus name if you'd like to change the volume of a specific bus only.
#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($Slider.value))



func switch_loops():
	if switching_loops:
		activating_main = !activating_main
	else:
		if AudioServer.is_bus_mute(main_loop_audio_bus):
			activating_main = true
			AudioServer.set_bus_mute(main_loop_audio_bus, false)
		else:
			activating_main = false
			AudioServer.set_bus_mute(distorted_loop_audio_bus, false)
	
	switching_loops = true

