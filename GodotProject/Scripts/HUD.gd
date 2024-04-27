class_name HUD
extends Control


@onready var target = $Target
@onready var timer_label = $TimerLabel
@onready var checkpoint_label = $CheckpointLabel
@onready var fps_label = $FPSLabel

@onready var pause_menu = $PauseMenu
@onready var options_menu = $OptionsMenu

var SFX_audio_bus = AudioServer.get_bus_index("SFX")
var music_audio_bus = AudioServer.get_bus_index("Music")

@onready var death_screen = $DeathScreen
@onready var animation_player = $"../AnimationPlayer"
@onready var cinematic_band_top = $CinematicBands/CinematicBandTop
@onready var cinematic_band_bottom = $CinematicBands/CinematicBandBottom

var start_time: int
var elapsed_time: int

var process_inputs = true


func _ready():
	# Play Intro
	animation_player.current_animation = "fade_to_black"
	animation_player.seek(animation_player.current_animation_length, true, true)
	Dialogic.start("Intro")
	await Dialogic.timeline_ended
	animation_player.play("fade_to_black", -1, -2, true)
	
	start_time = Time.get_ticks_msec() / 1000
	GameManager.checkpoint_reached.connect(_on_checkpoint_reached)


func _process(_delta):
	if fps_label.is_visible_in_tree():
		fps_label.text = str(Engine.get_frames_per_second())
	
	if timer_label.is_visible_in_tree():
		elapsed_time = (Time.get_ticks_msec() / 1000) - start_time
		var seconds = elapsed_time % 60
		var minutes = elapsed_time / 60
		timer_label.text = ("%02d" % minutes) + ":" + ("%02d" % seconds)


func disable_all():
	process_inputs = false
	target.hide()
	timer_label.hide()
	fps_label.hide()


func show_cinematic_bands(show_bands: bool):
	if show_bands:
		var cinematic_band_height = cinematic_band_top.size.y
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cinematic_band_top, "position:y", cinematic_band_top.position.y + cinematic_band_height, 1.5)
		tween.parallel().tween_property(cinematic_band_bottom, "position:y", cinematic_band_bottom.position.y - cinematic_band_height, 1.5)
	else:
		var cinematic_band_height = cinematic_band_top.size.y
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cinematic_band_top, "position:y", cinematic_band_top.position.y - cinematic_band_height, 1.5)
		tween.parallel().tween_property(cinematic_band_bottom, "position:y", cinematic_band_bottom.position.y + cinematic_band_height, 1.5)


func _unhandled_key_input(_event):
	
	if !process_inputs:
		return
	
	# DEBUGGING PURPOSES
	if Input.is_action_just_pressed("restart"):
		GameManager.respawn_player()
	if Input.is_action_just_pressed("pause"):
		if pause_menu.is_visible_in_tree():
			_on_resume_button_pressed()
		elif options_menu.is_visible_in_tree():
			_on_options_back_button_pressed()
		else:
			pause_menu.show()
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_checkpoint_reached():
	checkpoint_label.show()
	await get_tree().create_timer(3).timeout
	checkpoint_label.hide()


func respawn_player_animation():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	GameManager.respawn_player()
	animation_player.play("fade_to_black", -1, -1, true)


func last_hide(animation_speed: float):
	animation_player.play("fade_to_black", -1, animation_speed)


# Pause menu
func _on_resume_button_pressed():
	pause_menu.hide()
	get_tree().paused = false


func _on_options_button_pressed():
	pause_menu.hide()
	options_menu.show()


func _on_close_button_pressed():
	await Analytics.handle_exit()
	get_tree().quit()


# Options menu
func _on_timer_check_button_toggled(toggled_on):
	if toggled_on:
		timer_label.show()
	else:
		timer_label.hide()


func _on_fps_check_button_toggled(toggled_on):
	if toggled_on:
		fps_label.show()
	else:
		fps_label.hide()


func _on_options_back_button_pressed():
	options_menu.hide()
	pause_menu.show()


func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_audio_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(SFX_audio_bus, true)
	else:
		AudioServer.set_bus_mute(SFX_audio_bus, false)


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_audio_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(music_audio_bus, true)
	else:
		AudioServer.set_bus_mute(music_audio_bus, false)
