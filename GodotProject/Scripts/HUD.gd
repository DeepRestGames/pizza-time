extends Control


@onready var checkpoint_label = $CheckpointLabel


func _ready():
	GameManager.checkpoint_reached.connect(_on_checkpoint_reached)


func _on_checkpoint_reached():
	checkpoint_label.show()
	await get_tree().create_timer(3).timeout
	checkpoint_label.hide()
