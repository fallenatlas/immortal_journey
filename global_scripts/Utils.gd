extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"courage": Game.courage,
		"start": Game.startScene
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHP"]
				Game.courage = current_line["courage"]
				Game.startScene = current_line["start"]
				print(Game.startScene)
				
# Play test metrics

func reset_total_metrics():
	Game.n_deaths = 0
	Game.play_time = 0
	Game.total_living_world_t = 0
	Game.total_death_world_t = 0
	Game.total_goblins_killed = 0
	Game.total_archers_killed = 0
	print("total")

func reset_single_metrics():
	Game.run_time = 0
	Game.living_world_t = 0
	Game.death_world_t = 0
	Game.goblins_killed = 0
	Game.archers_killed = 0
	print("single")

func update_metrics():
	Game.play_time += Game.run_time
	Game.total_living_world_t += Game.living_world_t
	Game.total_death_world_t += Game.death_world_t
	Game.total_goblins_killed += Game.goblins_killed
	Game.total_archers_killed += Game.archers_killed
	print_metrics()
	reset_single_metrics()
	
func print_metrics():
	print("deaths: ", Game.n_deaths)
	print("run time: ", Game.run_time)
	print("play time: ", Game.play_time)
	print("time in living: ", Game.living_world_t)
	print("total time in living: ", Game.total_living_world_t)
	print("time in death: ", Game.death_world_t)
	print("total time in death: ", Game.total_death_world_t)
	print("goblins killed: ", Game.goblins_killed)
	print("total goblins killed: ", Game.total_goblins_killed)
	print("archers killed: ", Game.archers_killed)
	print("total archers killed: ", Game.total_archers_killed)

func log_death():
	Game.n_deaths += 1
	update_metrics()
	print("deaths: ", Game.n_deaths)
