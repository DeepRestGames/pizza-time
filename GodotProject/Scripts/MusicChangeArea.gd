extends Node3D


func _on_area_3d_body_entered(body):
	print("Body entered")
	
	if body is Player:
		Music.switch_loops()
