extends Area3D
class_name EndlessVoid


func _on_body_entered(body):
	if body is Player:
		var player = body as Player
		player.respawn_player()
