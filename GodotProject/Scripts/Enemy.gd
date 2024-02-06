class_name Enemy
extends CharacterBody3D


const SPEED = 3.0

var player = null

@onready var nav_agent = $NavigationAgent3D


func _physics_process(_delta):
	velocity = Vector3.ZERO
	
	if player != null:
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()


func _on_player_detection_area_body_entered(body):
	if body.name == "Player":
		print("Player found!")
		player = body


func _on_player_detection_area_body_exited(body):
	if body.name == "Player":
		print("Lost player!")
		player = null


func take_hit():
	print("Enemy hit!")
	queue_free()
