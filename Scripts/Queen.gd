extends Node2D

var pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func move(target):
		$Tween.interpolate_property(self, "position", pos * 47, target * 47, 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
		$Tween.start()
		
		pos = target

func destroy():
	get_parent().remove_child(self)
	queue_free()
