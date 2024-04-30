extends Control


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "ending_message":
		Music.switch_loops(2)
		Music.switch_loops(3)
		get_tree().change_scene_to_file("res://Scenes/Prototypes/MainMenu.tscn")
