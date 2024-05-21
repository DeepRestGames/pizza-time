extends Area3D

@export var dialogue: String


func _on_area_entered(area):
	Dialogic.start(dialogue)
