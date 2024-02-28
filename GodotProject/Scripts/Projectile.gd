extends Area3D


const SPEED = 20.0
@onready var despawn_timer = $DespawnTimer


func _ready():
	despawn_timer.start()


func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta


func _on_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		enemy.take_hit()
	
	if body is InteractableButton:
		var button = body as InteractableButton
		button.activate_button()
	
	if body is NPC:
		var npc = body as NPC
		npc.start_dialogue()
	
	queue_free()


func _on_despawn_timer_timeout():
	queue_free()
