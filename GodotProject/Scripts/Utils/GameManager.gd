extends Node


var player: Player
var player_respawn_point: Vector3 = Vector3(0, 1, 27)
signal checkpoint_reached


func set_player(player_instance: Player):
	player = player_instance


func set_respawn_point(new_point: Vector3):
	player_respawn_point = new_point
	checkpoint_reached.emit()


func respawn_player():
	player.position = player_respawn_point
