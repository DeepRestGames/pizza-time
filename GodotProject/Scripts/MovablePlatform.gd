class_name MovablePlatform
extends AnimatableBody3D


@onready var animation_player = $AnimationPlayer
var activated = false


func move_platform():
	if !activated:
		animation_player.play("move_platform")
		activated = true
