extends Node2D

var tile = preload("res://Scenes/Tile.tscn")

var queen = preload("res://Scenes/Queen.tscn")


var tile_grid = []

var enemies = []

var level_count = 1

var move_count = 2

var game_over = false

func _ready():
	game_over = false
	for i in range(-5, 6):
		for j in range(-5, 6):
			var t = tile.instance()
			t.position = Vector2(i * 47, j * 47)
			t.pos = Vector2(i, j)
			add_child(t)
			
			tile_grid.append(Vector2(i, j))
			
	# Set up the 'player'
	$Knight.position = Vector2(0, 4 * 47)
	$Knight.pos = Vector2(0, 4)
	$Knight.move($Knight.pos)
	
	$King.position = Vector2(0, -5 * 47)
	$King.pos = Vector2(0, -5)
	
	# Create Enemies
	randomize()
	for i in range(-5, 6):
		for j in range(-5, 6):
			if ($Knight.pos != Vector2(i, j) and $King.pos != Vector2(i, j)):
				if (rand_range(0, 1) < .05):
					var q = queen.instance()
					q.position = Vector2(i * 47, j * 47)
					q.pos = Vector2(i, j)
					enemies.append(q)
					add_child(q)
					
					print("Created")
					
func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene("res://Scenes/Intro.tscn")
	elif(Input.is_action_just_pressed("Restart")):
		get_tree().change_scene("res://Scenes/Game.tscn")

func move_enemies():
	for e in enemies:
		if (check_queen_valid(e.pos, $Knight.pos)):
			e.move($Knight.pos)
			game_over()
		else:
			var i = int(rand_range(-4, 5))
			var j = int(rand_range(-4, 5))
			
			var target = Vector2(i, j)
			
			if (check_queen_valid(e.pos, target)):
				e.move(Vector2(i, j))
	
func check_valid(pos):
	if (abs(pos[0] - $Knight.pos[0]) == 2 and abs(pos[1] - $Knight.pos[1]) == 1 or (abs(pos[0] - $Knight.pos[0]) == 1 and abs(pos[1] - $Knight.pos[1]) == 2)):
		return true
		
func check_queen_valid(pos, target):
	if (target != $King.pos):
		if (abs(target[0] - pos[0]) == 0 or abs(target[1] - pos[1]) == 0):
			return true
		elif (abs(target[0] - pos[0])/abs(target[1] - pos[1]) == 1):
			return true
		else:
			return false
	else:
		return false
	return false
	
		
func attempt_move(pos):
	if (check_valid(pos) and game_over == false):
		$Knight.move(pos)
		for e in enemies:
			if (e.pos == pos):
				e.destroy()
				enemies.erase(e)
		move_count -= 1
		
		if (move_count == 0):
			move_enemies()
			move_count = 2
			
		$Progress.reset_timer()
		
		if (game_over == false):
			$Moves.text = str(move_count) + " MOVES"
			if (move_count == 1):
				$Moves.text = "1 Move"
		
		
		if ($King.pos == pos):
			level_count = level_count + 1
			$"Level-Text".text = "LEVEL " + str(level_count)
			move_count = 2
			_ready()
			
func game_over():
	$"Level-Text".text = "GAME OVER"
	game_over = true
	$Progress/Timer.paused = true
	$Moves.text = "PRESS 'R'"
	


