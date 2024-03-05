extends Node3D


enum LevelsSignals {
	GROUND_LEVEL = 0,
	FIRST_LEVEL = 1,
	LABYRINT_LEVEL = 2,
	MEDITATING_SPHERE_LEVEL = 3,
	ROTATING_PLATFORMS_LEVEL = 4,
	CATAPULTS_LEVEL = 5,
	FINAL_LEVEL = 6
}

@export var checkpoint_signal: LevelsSignals
@onready var checkpoint_area = $Area3D


func _on_area_3d_body_entered(body):
	if body is Player:
		Analytics.add_event("Entered Level", {"Level": LevelsSignals.find_key(checkpoint_signal)})
		checkpoint_area.set_deferred("monitoring", false)
