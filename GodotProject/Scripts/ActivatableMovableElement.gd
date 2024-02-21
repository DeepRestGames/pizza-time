class_name ActivatableMovableElement
extends MovableElement


@export var base_button: Node3D
@export var animation_duration: float = 2.0
@onready var starting_position = $StartingPosition
@onready var ending_position = $EndingPosition


func move_platform():
	if !activated:
		var forward_tween = create_tween()
		forward_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		forward_tween.set_trans(Tween.TRANS_CUBIC)
		forward_tween.tween_property($ElevatorPivot, "position:y", ending_position.position.y, animation_duration)
		activated = true
	elif two_way_movement:
		var backward_tween = create_tween()
		backward_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		backward_tween.set_trans(Tween.TRANS_CUBIC)
		backward_tween.tween_property($ElevatorPivot, "position:y", starting_position.position.y, animation_duration)
		activated = false
	
	if base_button!= null && !base_button.visible:
		base_button.show()
	
