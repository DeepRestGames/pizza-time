class_name InteractableButton
extends StaticBody3D


@export var movable_platforms: Array[MovableElement]


func activate_button():
	for movable_platform in movable_platforms:
		movable_platform.move_platform()
