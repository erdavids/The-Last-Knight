extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.set_wait_time(5)
	$Timer.start()
	
func _process(delta):
	scale.x = .8 * ($Timer.time_left / 5)


func timeout():
	get_parent().game_over()
	
func reset_timer():
	$Timer.start()
