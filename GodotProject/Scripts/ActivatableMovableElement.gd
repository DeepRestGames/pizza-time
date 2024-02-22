class_name ActivatableMovableElement
extends MovableElement


@export var base_button: Node3D


func move_platform():
	super.move_platform()
	
	if base_button!= null && !base_button.visible:
		base_button.show()
	
