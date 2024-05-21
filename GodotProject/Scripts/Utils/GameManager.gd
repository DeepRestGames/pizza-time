extends Node


var player: Player
var starting_spawn_point = Vector3(0, 1, 27)
var player_respawn_point = starting_spawn_point

var checkpoint_saved = false
signal checkpoint_reached


func set_player(player_instance: Player):
	player = player_instance


func set_respawn_point(new_point: Vector3):
	checkpoint_saved = true
	player_respawn_point = new_point

	var extra_info := {}
	extra_info["last_checkpoint"] = new_point
	Dialogic.Save.save("save_slot04", false, Dialogic.Save.ThumbnailMode.NONE, extra_info)

	checkpoint_reached.emit()


func respawn_player():
	if checkpoint_saved:
		player.position = player_respawn_point
	else:
		player.position = starting_spawn_point


func reset_game():
	checkpoint_saved = false
	Dialogic.Save.delete_slot("save_slot04")


func check_for_saves():
	var extra_info = Dialogic.Save.get_slot_info("save_slot04")
	if extra_info and extra_info.has("last_checkpoint"):
		checkpoint_saved = true
		player_respawn_point = extra_info["last_checkpoint"]
	else:
		checkpoint_saved = false
