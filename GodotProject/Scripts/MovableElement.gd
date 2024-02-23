class_name MovableElement
extends Node3D


@onready var starting_node = $StartingNode
@onready var ending_node = $EndingNode
@onready var animation_pivot = $Pivot

@export var two_way_movement = false
@export var activated = false
@export var is_pausable = false

var tween
@export var animation_duration: float = 2.0
@export var animation_transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var animation_ease_type: Tween.EaseType = Tween.EASE_IN_OUT


# Reset the platform position and rotation on start
func _ready():
	
	
	if activated:
		animation_pivot.position = ending_node.position
		animation_pivot.rotation = ending_node.rotation
	else:
		animation_pivot.position = starting_node.position
		animation_pivot.rotation = starting_node.rotation


func move_platform():
	# Tween was already created
	if tween != null and tween.is_valid():
		# If tween is pausable execute pause logic, otherwise do nothing
		if is_pausable:
			if tween.is_running():
				tween.pause()
			else:
				tween.play()
	# New tween needs to be created
	else:
		if !activated:
			_start_animation(true)
			activated = true
		elif two_way_movement:
			_start_animation(false)
			activated = false


func _start_animation(forward: bool):
	tween = create_tween().set_parallel(true).set_trans(animation_transition_type).set_ease(animation_ease_type)
	if forward:
		tween.tween_property(animation_pivot, "position", ending_node.position, animation_duration)
		tween.tween_property(animation_pivot, "rotation", ending_node.rotation, animation_duration)
	else:
		tween.tween_property(animation_pivot, "position", starting_node.position, animation_duration)
		tween.tween_property(animation_pivot, "rotation", starting_node.rotation, animation_duration)
