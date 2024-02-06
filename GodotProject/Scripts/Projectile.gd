extends Area3D


const SPEED = 20.0
@onready var despawn_timer = $DespawnTimer


func _ready():
	despawn_timer.start()


func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta


func _on_body_entered(body):
	var enemy = body as Enemy
	if enemy != null:
		enemy.take_hit()
		queue_free()


func _on_despawn_timer_timeout():
	queue_free()
