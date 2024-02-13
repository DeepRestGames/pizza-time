extends MovableElement


@onready var move_timer = $MoveTimer
@export var move_time_interval = 2.0
@export var auto_start = false
var is_timer_running = false


func _ready():
	move_timer.wait_time = move_time_interval
	if auto_start:
		move_timer.start()


func move_platform():
	if not is_timer_running:
		move_timer.start()
	else:
		move_timer.stop()


func _on_move_timer_timeout():
	super.move_platform()
