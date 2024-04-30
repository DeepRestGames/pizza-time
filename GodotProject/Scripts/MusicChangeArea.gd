extends Node3D

@onready var area = $Area3D
@export var area_loop: LoopType

enum LoopType {
	MAIN_LOOP,
	DISTORTED_LOOP,
	AMBIENT_LOOP,
	MINIMAL_AMBIENT_LOOP
}


func _ready():
	await get_tree().create_timer(1)
	if area.has_overlapping_bodies():
		var overlapping_bodies = area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is Player:
				Music.switch_loops(area_loop)
				return

func _on_area_3d_body_entered(body):
	if body is Player:
		Music.switch_loops(area_loop)
