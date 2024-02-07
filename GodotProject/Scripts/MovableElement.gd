class_name MovableElement
extends Node3D


@onready var animation_player = $AnimatableBody3D/AnimationPlayer
@export var two_way_movement = false
@export var activated = false


func move_platform():
	if !activated:
		animation_player.play("move_forward")
		activated = true
	elif two_way_movement:
		animation_player.play("move_backward")
		activated = false
