class_name PickupItem
extends Area3D


@export var item_name: String


func _on_body_entered(body):
	var player = body as Player
	if player != null:
		player.pickup_item(item_name)
