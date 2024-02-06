class_name InteractableButton
extends StaticBody3D


@export var movable_platform: MovablePlatform


func activate_button():
	movable_platform.move_platform()
