class_name ActivatableMovableElement
extends MovableElement


@onready var base_button = $BaseButton


func move_platform():
	super.move_platform()
	
	if !base_button.visible:
		base_button.show()
	
