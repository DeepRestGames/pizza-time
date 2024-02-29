extends Area3D


const SPEED = 20.0
@onready var despawn_timer = $DespawnTimer
@onready var audio_stream_player = $AudioStreamPlayer3D
@export var pizza_throw_sounds: Array[AudioStreamWAV]
@export var pizza_hit_sounds: Array[AudioStreamWAV]

func _ready():
	despawn_timer.start()
	
	var audio_stream = pizza_throw_sounds.pick_random()
	audio_stream_player.stream = audio_stream
	audio_stream_player.play()


func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta


func _on_body_entered(body):
	var audio_stream = pizza_hit_sounds.pick_random()
	audio_stream_player.stream = audio_stream
	audio_stream_player.volume_db = 0
	audio_stream_player.play()
	
	if body is Enemy:
		var enemy = body as Enemy
		enemy.take_hit()
	
	if body is InteractableButton:
		var button = body as InteractableButton
		button.activate_button()
	
	if body is NPC:
		var npc = body as NPC
		npc.start_dialogue()
	
	await audio_stream_player.finished
	queue_free()


func _on_despawn_timer_timeout():
	queue_free()
