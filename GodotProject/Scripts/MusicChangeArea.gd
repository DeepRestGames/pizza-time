extends Node3D

@export var area_loop: LoopType

enum LoopType {
	MAIN_LOOP,
	DISTORTED_LOOP,
	AMBIENT_LOOP,
	MINIMAL_AMBIENT_LOOP
}

func _on_area_3d_body_entered(body):
	if body is Player:
		Music.switch_loops(area_loop)
