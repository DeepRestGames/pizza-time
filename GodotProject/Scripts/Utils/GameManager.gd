extends Node


var player: Player
var player_respawn_point: Vector3 = Vector3(0, 1, 27)
signal checkpoint_reached

# DEVELOPMENT - MOVE TO start_game WHEN MAIN MENU IS IMPLEMENTED
func _ready():
	start_game()
	#player = get_tree().get_root().get_node("MainScene/Player")
	#game_started.emit()


func start_game():
	player = get_tree().get_root().get_node("MainScene/Player")


func set_respawn_point(new_point: Vector3):
	player_respawn_point = new_point
	checkpoint_reached.emit()


func respawn_player():
	player.position = player_respawn_point
