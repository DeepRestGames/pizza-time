extends Node

@onready var main_loop = $AudioStreamPlayer_MainLoop
@onready var distorted_loop = $AudioStreamPlayer_DistortedLoop
@onready var ambient_loop = $AudioStreamPlayer_AmbientLoop
@onready var minimal_ambient_loop = $AudioStreamPlayer_AmbientLoopMinimal
@onready var music_player = $AudioStreamPlayer_FinalMusic
@onready var splash_sfx_player = $AudioStreamPlayer_SplashSFX
var main_loop_audio_bus = AudioServer.get_bus_index("Main_Loop")
var distorted_loop_audio_bus = AudioServer.get_bus_index("Distorted_Loop")
var ambient_loop_audio_bus = AudioServer.get_bus_index("Ambient_Loop")
var minimal_ambient_loop_audio_bus = AudioServer.get_bus_index("Ambient_Loop_Minimal")
var music_audio_bus = AudioServer.get_bus_index("Music")

var max_target_volume = 0
var min_target_volume = -30
var current_music_volume = max_target_volume
@export var loop_change_timescale = 0.5
var switching_loops = false

var current_loop: LoopType
var current_loop_bus: int
var previous_loop_bus: int

var stop_music_trigger = false

var music_started = false
var music_fade_in = false

enum LoopType {
	MAIN_LOOP,
	DISTORTED_LOOP,
	AMBIENT_LOOP,
	MINIMAL_AMBIENT_LOOP
}


func _ready():
	play_all_tracks(false)
	
	current_loop = LoopType.AMBIENT_LOOP
	current_loop_bus = ambient_loop_audio_bus
	previous_loop_bus = main_loop_audio_bus
	
	music_player.finished.connect(quit_game)


func _process(delta):
	if switching_loops:
		var current_loop_audio_bus_volume = AudioServer.get_bus_volume_db(current_loop_bus)
		var previous_loop_audio_bus_volume = AudioServer.get_bus_volume_db(previous_loop_bus)
		var current_loop_volume: float
		var previous_loop_volume: float
		
		current_loop_volume = lerpf(current_loop_audio_bus_volume, max_target_volume, delta * loop_change_timescale * 0.8)
		previous_loop_volume = lerpf(previous_loop_audio_bus_volume, min_target_volume, delta * loop_change_timescale * 1.3)
		
		AudioServer.set_bus_volume_db(current_loop_bus, current_loop_volume)
		AudioServer.set_bus_volume_db(previous_loop_bus, previous_loop_volume)
		
		if AudioServer.get_bus_volume_db(current_loop_bus) >= max_target_volume - 1:
			AudioServer.set_bus_mute(previous_loop_bus, true)
			AudioServer.set_bus_volume_db(previous_loop_bus, min_target_volume)
			AudioServer.set_bus_volume_db(current_loop_bus, max_target_volume)
			switching_loops = false
	
	if stop_music_trigger:
		var current_loop_audio_bus_volume = AudioServer.get_bus_volume_db(current_loop_bus)
		var current_loop_volume: float
		current_loop_volume = lerpf(current_loop_audio_bus_volume, min_target_volume, delta * loop_change_timescale)
		AudioServer.set_bus_volume_db(current_loop_bus, current_loop_volume)
		
		var music_audio_bus_volume = AudioServer.get_bus_volume_db(music_audio_bus)
		var music_volume: float
		music_volume = lerpf(music_audio_bus_volume, min_target_volume, delta * loop_change_timescale)
		AudioServer.set_bus_volume_db(music_audio_bus, music_volume)
		
		if AudioServer.get_bus_volume_db(music_audio_bus) <= min_target_volume + 1:
			AudioServer.set_bus_mute(current_loop_bus, true)
			AudioServer.set_bus_volume_db(current_loop_bus, min_target_volume)
			
			AudioServer.set_bus_volume_db(music_audio_bus, min_target_volume)
			stop_music_trigger = false
	
	if music_fade_in:
		var music_audio_bus_volume = AudioServer.get_bus_volume_db(music_audio_bus)
		var music_volume: float
		music_volume = lerpf(music_audio_bus_volume, current_music_volume, delta * loop_change_timescale * 0.8)
		AudioServer.set_bus_volume_db(music_audio_bus, music_volume)
		
		if AudioServer.get_bus_volume_db(music_audio_bus) >= max_target_volume - 1:
			AudioServer.set_bus_volume_db(music_audio_bus, max_target_volume)
			music_fade_in = false


func stop_music():
	stop_music_trigger = true
	switching_loops = false
	music_started = false


func play_all_tracks(play: bool):
	if play:
		main_loop.play(0)
		distorted_loop.play(0)
		ambient_loop.play(0)
		minimal_ambient_loop.play(0)
	else:
		main_loop.stop()
		distorted_loop.stop()
		ambient_loop.stop()
		minimal_ambient_loop.stop()


func get_music_volume():
	return current_music_volume


func set_music_volume(volume: float):
	current_music_volume = volume
	
	if not music_fade_in:
		AudioServer.set_bus_volume_db(music_audio_bus, volume)
		
		if volume == -30:
			AudioServer.set_bus_mute(music_audio_bus, true)
		else:
			AudioServer.set_bus_mute(music_audio_bus, false)


func play_final_music():
	AudioServer.set_bus_volume_db(music_audio_bus, min_target_volume)
	stop_music_trigger = false
	music_fade_in = true
	music_player.play()


func play_splash_sfx():
	splash_sfx_player.play()


func quit_game():
	await get_tree().create_timer(2).timeout
	stop_music()
	get_tree().change_scene_to_file("res://Scenes/Prototypes/EndingScreen_RedChoice.tscn")


func start_music():
	if not music_started:
		play_all_tracks(true)
		music_started = true


func switch_loops(new_loop):
	stop_music_trigger = false
	switching_loops = true
	start_music()
	
	var music_volume = AudioServer.get_bus_volume_db(music_audio_bus)
	if music_volume < current_music_volume:
		music_fade_in = true
	
	if new_loop != current_loop:
		previous_loop_bus = current_loop_bus
		current_loop = new_loop
	
		match new_loop:
			LoopType.MAIN_LOOP:
				current_loop_bus = main_loop_audio_bus
			LoopType.DISTORTED_LOOP:
				current_loop_bus = distorted_loop_audio_bus
			LoopType.AMBIENT_LOOP:
				current_loop_bus = ambient_loop_audio_bus
			LoopType.MINIMAL_AMBIENT_LOOP:
				current_loop_bus = minimal_ambient_loop_audio_bus
	
	AudioServer.set_bus_mute(current_loop_bus, false)
