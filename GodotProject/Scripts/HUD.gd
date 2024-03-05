extends Control


@onready var checkpoint_label = $CheckpointLabel
@onready var death_screen = $DeathScreen
@onready var animation_player = $"../AnimationPlayer"


func _ready():
	GameManager.checkpoint_reached.connect(_on_checkpoint_reached)


func _on_checkpoint_reached():
	checkpoint_label.show()
	await get_tree().create_timer(3).timeout
	checkpoint_label.hide()


func _on_endless_void_body_entered(_body):
	print("Fade to black animation start")
	
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	GameManager.respawn_player()
	animation_player.play("fade_to_black", -1, -2, true)
