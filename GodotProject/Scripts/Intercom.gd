class_name Intercom
extends StaticBody3D


@export var door_button: InteractableButton
var activated = false


func _ready():
	door_button.set_collision_layer_value(4, false)


func start_dialogue():
	if not activated:
		Dialogic.start("Intercom")
		await Dialogic.timeline_ended
		door_button.set_collision_layer_value(4, true)
		activated = true
	
